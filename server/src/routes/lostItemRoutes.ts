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
import { acceptClaim, rejectClaim, submitClaim } from '../controllers/claimController';

const lostItemRouter = Router();

lostItemRouter.post('/add', createLostItem);
lostItemRouter.get('/nearby', getNearbyLostItems); // Put this route before the ':id' route
lostItemRouter.get('/getAll', getAllLostItems);
lostItemRouter.get('/search', searchLostItem);
lostItemRouter.get('/:id', getLostItemById); // Place this after 'nearby'
lostItemRouter.put('/update/:id', updateLostItem);
lostItemRouter.delete('/delete/:id', deleteLostItem);

//claims routes
lostItemRouter.post('/claim/submit', submitClaim);
lostItemRouter.post('/claim/accept', acceptClaim);
lostItemRouter.post('/claim/reject', rejectClaim);
export default lostItemRouter;
