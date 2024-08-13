"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const lostItemController_1 = require("../controllers/lostItemController");
const claimController_1 = require("../controllers/claimController");
const auth_1 = require("../middlewares/auth");
const lostItemRouter = (0, express_1.Router)();
lostItemRouter.post('/add', auth_1.auth, lostItemController_1.createLostItem);
lostItemRouter.get('/nearby', lostItemController_1.getNearbyLostItems);
lostItemRouter.get('/getAll', lostItemController_1.getAllLostItems);
lostItemRouter.get('/search', lostItemController_1.searchLostItem);
lostItemRouter.get('/:id', lostItemController_1.getLostItemById);
lostItemRouter.put('/update/:id', auth_1.auth, lostItemController_1.updateLostItem);
lostItemRouter.delete('/delete/:id', auth_1.auth, lostItemController_1.deleteLostItem);
// Claims routes with authentication
lostItemRouter.post('/claim/submit', auth_1.auth, claimController_1.submitClaim);
lostItemRouter.post('/claim/accept', auth_1.auth, claimController_1.acceptClaim);
lostItemRouter.post('/claim/reject', auth_1.auth, claimController_1.rejectClaim);
exports.default = lostItemRouter;
