import { Router, Request, Response } from 'express';
import { registerUser, loginUser ,tokenIsValid, updateUserLocation} from '../controllers/authController';
import jwt, { JwtPayload } from 'jsonwebtoken';
import {auth} from '../middlewares/auth';
import User from '../models/user';
const authRouter = Router();

authRouter.post('/register', registerUser);
authRouter.post('/login', loginUser);
authRouter.post('/tokenIsValid',tokenIsValid);
authRouter.patch('/:userId/location', updateUserLocation);



authRouter.get("/user", auth, async (req: Request, res: Response) => {
    try {
      if (!req.user) {
        return res.status(400).json({ msg: "User ID not found in request." });
      }
  
      const user = await User.findById(req.user);
      if (!user) {
        return res.status(404).json({ msg: "User not found." });
      }
  
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  });

export default authRouter;
