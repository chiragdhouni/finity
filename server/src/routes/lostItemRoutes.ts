import { Router } from 'express';
import {
    createLostItem,
    getLostItemById,
    getAllLostItems,
    updateLostItem,
    deleteLostItem
} from '../controllers/lostItemController';

const lostItemRouter = Router();

lostItemRouter.post('/add', createLostItem);
lostItemRouter.get('/:id', getLostItemById);
lostItemRouter.get('/', getAllLostItems);
lostItemRouter.put('/:id', updateLostItem);
lostItemRouter.delete('/:id', deleteLostItem);



export default lostItemRouter;
