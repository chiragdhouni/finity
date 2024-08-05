import { Request, Response } from 'express';
import Item from '../models/item';
import User from '../models/user';
import { ObjectId } from 'mongodb';

// Adding an item to be listed for lending

export const addItem = async (req: Request, res: Response) => {
  const { name, description, category, ownerId, dueDate } = req.body;
  try {
    if(!name || !description || !category || !ownerId) { 
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
        address: owner.address
      },
      status: 'available',
      location: owner.location,
      dueDate: dueDate ? new Date(dueDate) : null, // Parse and set the due date if provided
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
  const { itemId, borrowerId, dueDate } = req.body;
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
    res.status(200).send({
      message: 'Borrow request submitted',
      item,
      borrower,
      proposedDueDate: dueDate
    });
  } catch (error) {
    console.error(`Error requesting to borrow item: ${(error as Error).message}`);
    res.status(400).send(error);
  }
};

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
      await owner.save();
    }

    borrower.itemsBorrowed.push(itemId as ObjectId);
    borrower.itemsRequested = borrower.itemsRequested.filter(
      (requestedItemId) => requestedItemId !== itemId
    );
    await borrower.save();

    res.status(200).send(item);
  } catch (error) {
    console.error(`Error lending item: ${(error as Error).message}`);
    res.status(400).send(error);
  }
};

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
          maxDistance: parseFloat(maxDistance as string ), // Maximum distance in meters
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
          // distance: '$dist.calculated',
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
      // Remove item from borrower's itemsBorrowed list
      borrower.itemsBorrowed = borrower.itemsBorrowed.filter(
        (borrowedItemId) => borrowedItemId !== itemId
      );
      await borrower.save();
  
      // Remove item from owner's itemsLended list
      const owner = await User.findById(item.owner.id);
      if (owner) {
        owner.itemsLended = owner.itemsLended.filter(
          (lendedItemId) => lendedItemId !== itemId
        );
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
