import { Request, Response } from 'express';
import LostItem from '../models/lostItem';

// Create a new lost item
export const createLostItem = async (req: Request, res: Response) => {
    try {
        const lostItem = new LostItem(req.body);
        await lostItem.save();
        return res.status(201).json(lostItem);
    } catch (err) {
        return res.status(400).json({ error: 'Error creating lost item', details: err });
    }
};

// Get a lost item by ID
export const getLostItemById = async (req: Request, res: Response) => {
    try {
        const lostItem = await LostItem.findById(req.params.id);
        if (!lostItem) {
            return res.status(404).json({ error: 'Lost item not found' });
        }
        return res.status(200).json(lostItem);
    } catch (err) {
        return res.status(400).json({ error: 'Error fetching lost item', details: err });
    }
};

// Get all lost items
export const getAllLostItems = async (req: Request, res: Response) => {
    try {
        const lostItems = await LostItem.find();
        return res.status(200).json(lostItems);
    } catch (err) {
        return res.status(400).json({ error: 'Error fetching lost items', details: err });
    }
};

// Update a lost item by ID
export const updateLostItem = async (req: Request, res: Response) => {
    try {
        const lostItem = await LostItem.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!lostItem) {
            return res.status(404).json({ error: 'Lost item not found' });
        }
        return res.status(200).json(lostItem);
    } catch (err) {
        return res.status(400).json({ error: 'Error updating lost item', details: err });
    }
};

// Delete a lost item by ID
export const deleteLostItem = async (req: Request, res: Response) => {
    try {
        const lostItem = await LostItem.findByIdAndDelete(req.params.id);
        if (!lostItem) {
            return res.status(404).json({ error: 'Lost item not found' });
        }
        return res.status(200).json({ message: 'Lost item deleted successfully' });
    } catch (err) {
        return res.status(400).json({ error: 'Error deleting lost item', details: err });
    }
};

// // Search for lost items by location
// export const searchLostItemsByLocation = async (req: Request, res: Response) => {
//     const { longitude, latitude, maxDistance } = req.query;

//     try {
//         const lostItems = await LostItem.find({
//             location: {
//                 $near: {
//                     $geometry: {
//                         type: 'Point',
//                         coordinates: [parseFloat(longitude as string), parseFloat(latitude as string)],
//                     },
//                     $maxDistance: parseInt(maxDistance as string),
//                 },
//             },
//         });

//         return res.status(200).json(lostItems);
//     } catch (err) {
//         return res.status(400).json({ error: 'Error searching lost items by location', details: err });
//     }
// };

// get nearby lost items
export const getNearbyLostItems = async (req: Request, res: Response) => {
    const { longitude, latitude, maxDistance } = req.query;

    try {
        const lostItems = await LostItem.find({
            location: {
                $near: {
                    $geometry: {
                        type: 'Point',
                        coordinates: [parseFloat(longitude as string), parseFloat(latitude as string)],
                    },
                    $maxDistance: parseInt(maxDistance as string),
                },
            },
        });

        return res.status(200).json(lostItems);
    } catch (err) {
        return res.status(400).json({ error: 'Error fetching nearby lost items', details: err });
    }
};


//search lost item
export const searchLostItem = async (req: Request, res: Response) => {
    const { query } = req.query;

    try {
        const lostItems = await LostItem.find({
            $or: [
                { title: { $regex: query as string, $options: 'i' } },
                { description: { $regex: query as string, $options: 'i' } },
            ],
        });

        return res.status(200).json(lostItems);
    } catch (err) {
        return res.status(400).json({ error: 'Error searching lost items', details: err });
    }
}