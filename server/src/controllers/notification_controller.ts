import { Request, Response } from 'express';
import { Notification } from '../models/notification';

  export const getUserNotifications = async (req: Request, res: Response) => {
    try {
      if(!req.user){
        return res.status(401).json({ msg: 'Unauthorized: User not found' });
      }
      const userId = req.user.id;
  
      const notifications = await Notification.find({ userId })
        .sort({ createdAt: -1 })
        .exec();
  
      res.status(200).json(notifications);
    } catch (err) {
      res.status(500).json({ error: 'Error fetching notifications', details: err });
    }
  };