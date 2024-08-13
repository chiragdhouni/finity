import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import  User  from '../models/user'; // Adjust the import according to your project structure

// Define the type for the JWT payload
interface JwtPayload {
  id: string;
}

// Define a middleware function for authentication
export const auth = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const token = req.header('x-auth-token');
    if (!token) {
      return res.status(401).json({ msg: 'No auth token, access denied' });
    }

    const verified = jwt.verify(token, 'passwordKey') as JwtPayload; // Type assertion for JWT payload
    if (!verified) {
      return res.status(401).json({ msg: 'Token verification failed, authorization denied.' });
    }

    // Retrieve user from the database
    const user = await User.findById(verified.id).exec();
    if (!user) {
      return res.status(401).json({ msg: 'User not found' });
    }

    req.user = user; // Assign the full user object to req.user
    req.token = token; // Optionally assign the token to req.token
    next(); // Move to the next middleware
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
};
