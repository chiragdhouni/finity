import { Router } from 'express';
import {
  addItem,
  requestToBorrowItem,
  lendItem,
  returnItem,
  getItemsByLocation
} from '../controllers/itemController';

const itemRouter = Router();

itemRouter.post('/add', addItem);
itemRouter.post('/request', requestToBorrowItem);
itemRouter.put('/lend', lendItem);
itemRouter.put('/return', returnItem);
itemRouter.get('/location', getItemsByLocation);

export default itemRouter;
