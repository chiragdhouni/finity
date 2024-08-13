import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import  User  from '../models/user'; // Adjust the import according to your project structure

// Define the type for the JWT payload
interface JwtPayload {
  id: string;
}export const auth = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const token = req.header('x-auth-token');
    if (!token) {
      console.log('No token provided');
      return res.status(401).json({ msg: 'No auth token, access denied' });
    }

    const verified = jwt.verify(token, 'passwordKey') as JwtPayload;
    if (!verified) {
      console.log('Token verification failed');
      return res.status(401).json({ msg: 'Token verification failed, authorization denied.' });
    }

    const user = await User.findById(verified.id).exec();
    if (!user) {
      console.log('User not found for ID:', verified.id);
      return res.status(401).json({ msg: 'User not found' });
    }

    req.user = user;
    req.token = token;
    next();
  } catch (err: any) {
    console.log('Middleware Error:', err.message);
    res.status(500).json({ error: err.message });
  }
};
