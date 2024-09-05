import { Router } from 'express';
import {
  addItem,
  requestToBorrowItem,
  lendItem,
  returnItem,
  getNearbyItems,
  searchItems,
  getItemByIds,
 
} from '../controllers/itemController';
import { auth } from '../middlewares/auth';

const itemRouter = Router();

itemRouter.post('/add', auth,addItem);
itemRouter.post('/request',auth, requestToBorrowItem);
itemRouter.put('/lend', auth, lendItem);
itemRouter.put('/return', auth, returnItem);
itemRouter.get('/nearby', auth, getNearbyItems);
itemRouter.get('/search', auth,searchItems);
itemRouter.post('/getItemByIds', auth,getItemByIds);
export default itemRouter;
