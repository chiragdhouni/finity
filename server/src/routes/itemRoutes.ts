import { Router } from 'express';
import {
  addItem,
  requestToBorrowItem,
  lendItem,
  returnItem,
  getNearbyItems,
 
} from '../controllers/itemController';

const itemRouter = Router();

itemRouter.post('/add', addItem);
itemRouter.post('/request', requestToBorrowItem);
itemRouter.put('/lend', lendItem);
itemRouter.put('/return', returnItem);
itemRouter.get('/nearby', getNearbyItems);

export default itemRouter;
