import { Request, Response } from 'express';
import Item from '../models/item';
import User from '../models/user';
import { ObjectId } from 'mongodb';

// Adding an item to be listed for lending
export const addItem = async (req: Request, res: Response) => {
  const { name, description, category, ownerId, dueDate ,address} = req.body;
  try {
    if (!name || !description || !category || !ownerId) {
      return res.status(400).send('Missing required fields');
    }

    const owner = await User.findById(ownerId);
    if (!owner) {
      return res.status(404).send('Owner not found');
    }

    const item = new Item({
      name,
      description,
      category,
      owner: {
        id: owner._id,
        name: owner.name,
        email: owner.email,
        address: owner.address,
      },
      status: 'available',
      location: owner.location,
      dueDate: dueDate ? new Date(dueDate) : null, // Parse and set the due date if provided
      address :address,
    });

    await item.save();
    owner.itemsListed.push(item._id as ObjectId);
    await owner.save();

    res.status(201).send(item);
  } catch (error) {
    console.error(`Error adding item: ${(error as Error).message}`);
    res.status(400).send(error);
  }
};

// Request to borrow an item
export const requestToBorrowItem = async (req: Request, res: Response) => {
  const { itemId, borrowerId } = req.body;

  try {
    const item = await Item.findById(itemId);
    if (!item) {
      return res.status(404).send('Item not found');
    }

    if (item.status !== 'available') {
      return res.status(400).send('Item is not available for borrowing');
    }

    const borrower = await User.findById(borrowerId);
    if (!borrower) {
      return res.status(404).send('Borrower not found');
    }

    borrower.itemsRequested.push(itemId);
    await borrower.save();

    const owner = await User.findById(item.owner.id);
    if (owner) {
      const notification = {
        userId: req.user?._id as any,
        itemId: item._id,
        type: 'borrowRequest',
        message: `Someone has requested to borrow your item: ${item.name}.`,
        read: false,
      };

      owner.notifications.push({
        userId: notification.userId,
        itemId: notification.itemId as ObjectId,
        type: notification.type,
        message: notification.message,
        read: notification.read,
        createdAt : new Date(),
      });
      await owner.save();
    }

    res.status(200).send({
      message: 'Borrow request submitted',
      item,
      borrower,
    });
  } catch (error) {
    console.error(`Error requesting to borrow item: ${(error as Error).message}`);
    res.status(500).send('Internal server error');
  }
};

// Lend an item
export const lendItem = async (req: Request, res: Response) => {
  const { itemId, borrowerId, dueDate } = req.body;
  try {
    const item = await Item.findById(itemId);
    if (!item) {
      return res.status(404).send('Item not found');
    }
    if (item.status !== 'available') {
      return res.status(400).send('Item is not available for lending');
    }
    const borrower = await User.findById(borrowerId);
    if (!borrower) {
      return res.status(404).send('Borrower not found');
    }

    item.status = 'lended';
    item.dueDate = dueDate;
    item.borrower = {
      id: borrower._id as ObjectId,
      name: borrower.name,
      email: borrower.email,
      address: borrower.address,
    };
    await item.save();

    const owner = await User.findById(item.owner.id);
    if (owner) {
      owner.itemsLended.push(itemId as ObjectId);

      // Mark the old notification as read and remove it from owner's notifications
      const oldNotification = owner.notifications.find(
        (n) => n.userId.toString() === (borrower._id  as any).toString() && n.type === 'borrowRequest'
      );
      if (oldNotification) {
        oldNotification.read = true;
       
      }

      // owner.notifications.push({
      //   userId: req.user?._id as any,  
      //   itemId: item._id  as any,
      //   type: 'borrowRequestAccepted',
      //   message: `Your borrow request for ${item.name} has been accepted.`,
      //   read: false,
      // });

      await owner.save();
    }

    borrower.itemsBorrowed.push(itemId as ObjectId);
    borrower.itemsRequested = borrower.itemsRequested.filter(
      (requestedItemId) => requestedItemId.toString() !== itemId.toString()
    );
    borrower.notifications.push({
      userId: item.owner.id  as any,
      itemId: item._id  as any,
      type: 'borrowRequestAccepted',
      message: `Your borrow request for ${item.name} has been accepted.`,
      read: false,
      createdAt : new Date(),
    });
    await borrower.save();

    res.status(200).send(item);
  } catch (error) {
    console.error(`Error lending item: ${(error as Error).message}`);
    res.status(400).send(error);
  }
};

// Get nearby items
export const getNearbyItems = async (req: Request, res: Response) => {
  const { latitude, longitude, maxDistance } = req.query;

  try {
    const items = await Item.aggregate([
      {
        $geoNear: {
          near: {
            type: 'Point',
            coordinates: [parseFloat(longitude as string), parseFloat(latitude as string)],
          },
          distanceField: 'dist.calculated',
          maxDistance: parseFloat(maxDistance as string), // Maximum distance in meters
          spherical: true,
        },
      },
      {
        $project: {
          name: 1,
          description: 1,
          category: 1,
          status: 1,
          owner: 1,
          borrower: 1,
          dueDate: 1,
          location: 1,
          address: 1,
        },
      },
    ]);

    res.status(200).json(items);
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
};

// Return an item
export const returnItem = async (req: Request, res: Response) => {
  const { itemId } = req.body;
  try {
    const item = await Item.findById(itemId);
    if (!item) {
      return res.status(404).send('Item not found');
    }
    if (item.status !== 'lended') {
      return res.status(400).send('Item is not currently lended');
    }

    const borrower = await User.findById(item.borrower?.id);
    if (!borrower) {
      return res.status(404).send('Borrower not found');
    }

    borrower.itemsBorrowed = borrower.itemsBorrowed.filter(
      (borrowedItemId) => borrowedItemId.toString() !== itemId.toString()
    );
    await borrower.save();

    const owner = await User.findById(item.owner.id);
    if (owner) {
      owner.itemsLended = owner.itemsLended.filter(
        (lendedItemId) => lendedItemId.toString() !== itemId.toString()
      );

      // Add a notification to the owner that the item was returned
      owner.notifications.push({
        userId: borrower._id  as any,
        itemId: item._id  as any,
        type: 'itemReturned',
        message: `The item ${item.name} has been returned.`,
        read: false,
        createdAt : new Date(),
      });

      await owner.save();
    }

    // Reset item fields
    item.status = 'available';
    item.dueDate = null;
    item.borrower = null;
    await item.save();

    res.status(200).send(item);
  } catch (error) {
    console.error(`Error returning item: ${(error as Error).message}`);
    res.status(400).send(error);
  }
};

// Search for items
export const searchItems = async (req: Request, res: Response) => {
  const { query } = req.query;
  try {
    const items = await Item.find({ name: { $regex: query as string, $options: 'i' } });
    res.status(200).json(items);
  } catch (error) {
    console.error(`Error searching items: ${(error as Error).message}`);
    res.status(400).send(error);
  }
};

// Reject borrow request
export const rejectBorrowRequest = async (req: Request, res: Response) => {
  const { itemId, borrowerId } = req.body;
  try {
    const item = await Item.findById(itemId);
    if (!item) {
      return res.status(404).send('Item not found');
    }
    const borrower = await User.findById(borrowerId);
    if (!borrower) {
      return res.status(404).send('Borrower not found');
    }

    borrower.itemsRequested = borrower.itemsRequested.filter(
      (requestedItemId) => requestedItemId.toString() !== itemId.toString()
    );
    borrower.notifications.push({
      userId: item.owner.id,
      itemId: item._id  as any,
      type: 'borrowRequestRejected',
      message: `Your borrow request for ${item.name} has been rejected.`,
      read: false,
      createdAt : new Date(),
    });
    await borrower.save();

    const owner = await User.findById(item.owner.id);
    if (owner) {
      owner.notifications.push({
        userId: borrower._id as any,
        itemId: item._id  as any,
        type: 'borrowRequestRejected',
        message: `You have rejected the borrow request for ${item.name}.`,
        read: false,
        createdAt : new Date(),
      });
      await owner.save();
    }

    res.status(200).send('Borrow request rejected');
  } catch (error) {
    console.error(`Error rejecting borrow request: ${(error as Error).message}`);
    res.status(400).send(error);
  }
};


export const getItemByIds = async (req: Request, res: Response) => {

  const { itemIds } = req.body;
  try {
    const items = await Item.find({ _id: { $in: itemIds } });
    res.status(200).json(items);
  } catch (error) {
    console.error(`Error getting items by ids: ${(error as Error).message}`);
    res.status(400).send(error);
  }
};
