import { Router } from 'express';
import {
    createLostItem,
    getLostItemById,
    getAllLostItems,
    updateLostItem,
    deleteLostItem,
    getNearbyLostItems,
    searchLostItem
} from '../controllers/lostItemController';

const lostItemRouter = Router();

lostItemRouter.post('/add', createLostItem);
lostItemRouter.get('/:id', getLostItemById);
lostItemRouter.get('/getAll', getAllLostItems);
lostItemRouter.put('/update/:id', updateLostItem);
lostItemRouter.delete('/delete/:id', deleteLostItem);
lostItemRouter.get('/nearby', getNearbyLostItems);
lostItemRouter.get('/search', searchLostItem); 


export default lostItemRouter;
