import { Router, Request, Response } from 'express';
import { registerUser, loginUser ,tokenIsValid, updateUserLocation} from '../controllers/authController';
import jwt, { JwtPayload } from 'jsonwebtoken';
import {auth} from '../middlewares/auth';
import User from '../models/user';

const authRouter = Router();

authRouter.post('/register', registerUser);
authRouter.post('/login', loginUser);
authRouter.get('/tokenIsValid',tokenIsValid);
authRouter.patch('/:userId/location', updateUserLocation);


authRouter.get("/user", auth, async (req: Request, res: Response) => {
  try {
    // Since req.user now contains the full user object
    const user = req.user;

    if (!user) {
      return res.status(404).json({ msg: "User not found." });
    }

    // Retrieve the token from the request header
    const token = req.header('x-auth-token');

    // Add the token to the response object
    res.status(200).json({ token, user });
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

export default authRouter;