import { Router } from 'express';
import { auth } from '../middlewares/auth';

import {
    getUserById,
    updateUser,
  } from '../controllers/userController';
const userRouter = Router();

userRouter.get('/getUserById', auth, getUserById);
userRouter.put('/updateUser', auth, updateUser);

export default userRouter;