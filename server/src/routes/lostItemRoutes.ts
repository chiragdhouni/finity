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
import { auth } from '../middlewares/auth';

const lostItemRouter = Router();

lostItemRouter.post('/add', auth, createLostItem);
lostItemRouter.get('/nearby', getNearbyLostItems);
lostItemRouter.get('/getAll', getAllLostItems);
lostItemRouter.get('/search', searchLostItem);
lostItemRouter.get('/:id', getLostItemById);
lostItemRouter.put('/update/:id', auth, updateLostItem);
lostItemRouter.delete('/delete/:id', auth, deleteLostItem);

// Claims routes with authentication
lostItemRouter.post('/claim/submit', auth, submitClaim);
lostItemRouter.post('/claim/accept', auth, acceptClaim);
lostItemRouter.post('/claim/reject', auth, rejectClaim);

export default lostItemRouter;
