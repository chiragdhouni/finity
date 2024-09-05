import { Router } from 'express';
import { auth } from '../middlewares/auth';
import user from '../models/user';
import {
    getUserById,
  } from '../controllers/userController';
const userRouter = Router();

userRouter.get('/getUserById', auth, getUserById);

export default userRouter;