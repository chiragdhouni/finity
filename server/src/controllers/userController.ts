import User from '../models/user';
import { Request, Response } from 'express';

export const getUserById = async (req: Request, res: Response) => {
    try {
        const userId = req.user?._id; // Extracting userId from req.user set by middleware
        if (!userId) {
            return res.status(400).json({ error: 'User ID not found in request' });
        }

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.status(200).json({ user });
    } catch (err) {
        res.status(500).json({ error: 'Error getting user', details: err });
    }
};

export const updateUser = async (req: Request, res: Response) => {
    try {
        const userId = req.user?._id;
        if (!userId) {
            return res.status(400).json({ error: 'User ID not found in request' });
        }

        const user = await User.findByIdAndUpdate(userId, req.body, { new: true });
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.status(200).json({ user });
    } catch (err) {
        res.status(500).json({ error: 'Error updating user', details: err });
    }
};
