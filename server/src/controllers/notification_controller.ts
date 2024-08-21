import { Request, Response } from 'express';
import { Notification } from '../models/notification';

export const getNotificationsForIds = async (req: Request, res: Response) => {
  try {
    const notificationIds = req.body.notificationIds; // Ensure you're passing 'notificationIds' in the request body
    const notifications = await Notification.find({ _id: { $in: notificationIds } })
      .sort({ createdAt: -1 })
      .exec();

    return res.status(200).json(notifications);
  } catch (err) {
    console.error('Error fetching notifications:', err);
    return res.status(500).json({ error: 'Error fetching notifications' });
  }
};
