import { Router } from 'express';
import {
  addItem,
  requestToBorrowItem,
  lendItem,
  returnItem,
  getNearbyItems,
  searchItems,
 
} from '../controllers/itemController';

const itemRouter = Router();

itemRouter.post('/add', addItem);
itemRouter.post('/request', requestToBorrowItem);
itemRouter.put('/lend', lendItem);
itemRouter.put('/return', returnItem);
itemRouter.get('/nearby', getNearbyItems);
itemRouter.get('/search',searchItems);

export default itemRouter;
