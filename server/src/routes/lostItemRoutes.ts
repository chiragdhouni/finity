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
lostItemRouter.get('/nearby', getNearbyLostItems); // Put this route before the ':id' route
lostItemRouter.get('/getAll', getAllLostItems);
lostItemRouter.get('/search', searchLostItem);
lostItemRouter.get('/:id', getLostItemById); // Place this after 'nearby'
lostItemRouter.put('/update/:id', updateLostItem);
lostItemRouter.delete('/delete/:id', deleteLostItem);

export default lostItemRouter;
