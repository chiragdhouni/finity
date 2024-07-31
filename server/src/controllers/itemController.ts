import { Request, Response } from 'express';
import Item from '../models/item';
import User from '../models/user';

// Adding an item to be listed for lending
export const addItem = async (req: Request, res: Response) => {
  const { name, description, category, ownerId, location } = req.body;
  try {
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
        location: owner.location
      },
      status: 'available',
      location
    });
    await item.save();
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

// Confirm the lending of an item
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
      id: borrower._id as string,
      name: borrower.name,
      email: borrower.email,
      location: borrower.location
    };
    await item.save();

    const owner = await User.findById(item.owner.id);
    if (owner) {
      owner.itemsLended.push(itemId);
      await owner.save();
    }

    borrower.itemsBorrowed.push(itemId);
    await borrower.save();

    res.status(200).send(item);
  } catch (error) {
    console.error(`Error lending item: ${(error as Error).message}`);
    res.status(400).send(error);
  }
};

// Get items by location
export const getItemsByLocation = async (req: Request, res: Response) => {
  const { location } = req.query;
  try {
    const items = await Item.find({ location });
    res.status(200).send(items);
  } catch (error) {
    console.error(`Error fetching items: ${(error as Error).message}`);
    res.status(400).send(error);
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

    // Reset item fields
    item.status = 'available';
    item.dueDate = undefined;
    item.borrower = undefined;
    await item.save();

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

    res.status(200).send(item);
  } catch (error) {
    console.error(`Error returning item: ${(error as Error).message}`);
    res.status(400).send(error);
  }
};
