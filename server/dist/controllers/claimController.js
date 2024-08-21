"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.rejectClaim = exports.acceptClaim = exports.submitClaim = void 0;
const claim_1 = require("../models/claim");
const lostItem_1 = __importDefault(require("../models/lostItem"));
const user_1 = __importDefault(require("../models/user"));
const submitClaim = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { lostItemId, proofText, proofImages } = req.body;
        if (!req.user) {
            return res.status(401).json({ msg: `Unauthorized: User not found` });
        }
        const userId = req.user.id;
        const claim = new claim_1.Claim({
            userId,
            lostItemId,
            proofText,
            proofImages,
        });
        yield claim.save();
        yield lostItem_1.default.findByIdAndUpdate(lostItemId, {
            $push: { claims: claim._id },
        });
        const lostItem = yield lostItem_1.default.findById(lostItemId).populate('owner.id');
        const owner = yield user_1.default.findById(lostItem === null || lostItem === void 0 ? void 0 : lostItem.owner.id);
        owner === null || owner === void 0 ? void 0 : owner.notifications.push({
            userId: req.user._id,
            itemId: lostItem === null || lostItem === void 0 ? void 0 : lostItem._id,
            message: `You have a new claim for the item: ${lostItem === null || lostItem === void 0 ? void 0 : lostItem.name} from ${req.user.name}`,
            type: 'claimRequest',
            read: false,
            createdAt: new Date(),
        });
        yield (owner === null || owner === void 0 ? void 0 : owner.save());
        res.status(201).json({ message: 'Claim submitted successfully', claim });
    }
    catch (err) {
        res.status(500).json({ error: 'Error submitting claim', details: err });
    }
});
exports.submitClaim = submitClaim;
const acceptClaim = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { claimId } = req.body;
        const claim = yield claim_1.Claim.findById(claimId);
        if (!claim) {
            return res.status(404).json({ error: 'Claim not found' });
        }
        if (!req.user) {
            return res.status(401).json({ msg: 'Unauthorized: User not found' });
        }
        const lostItem = yield lostItem_1.default.findById(claim.lostItemId);
        if ((lostItem === null || lostItem === void 0 ? void 0 : lostItem.owner.id.toString()) !== req.user.id.toString()) {
            return res.status(403).json({ error: 'You are not authorized to accept this claim' });
        }
        claim.status = 'accepted';
        yield claim.save();
        const claimPerson = yield user_1.default.findById(claim.userId);
        claimPerson === null || claimPerson === void 0 ? void 0 : claimPerson.notifications.push({
            userId: req.user._id,
            itemId: lostItem === null || lostItem === void 0 ? void 0 : lostItem._id,
            message: `Your claim for the item: ${lostItem === null || lostItem === void 0 ? void 0 : lostItem.name} has been accepted.`,
            type: 'claimRequestAccepted',
            read: false,
            createdAt: new Date(),
        });
        yield (claimPerson === null || claimPerson === void 0 ? void 0 : claimPerson.save());
        lostItem.status = 'found';
        yield lostItem.save();
        res.status(200).json({ message: 'Claim accepted successfully', claim });
    }
    catch (err) {
        res.status(500).json({ error: 'Error accepting claim', details: err });
    }
});
exports.acceptClaim = acceptClaim;
const rejectClaim = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { claimId } = req.body;
        const claim = yield claim_1.Claim.findById(claimId);
        if (!claim) {
            return res.status(404).json({ error: 'Claim not found' });
        }
        if (!req.user) {
            return res.status(401).json({ msg: 'Unauthorized: User not found' });
        }
        const lostItem = yield lostItem_1.default.findById(claim.lostItemId);
        if ((lostItem === null || lostItem === void 0 ? void 0 : lostItem.owner.id.toString()) !== req.user.id.toString()) {
            return res.status(403).json({ error: 'You are not authorized to reject this claim' });
        }
        claim.status = 'rejected';
        yield claim.save();
        const claimPerson = yield user_1.default.findById(claim.userId);
        claimPerson === null || claimPerson === void 0 ? void 0 : claimPerson.notifications.push({
            userId: req.user._id,
            itemId: lostItem === null || lostItem === void 0 ? void 0 : lostItem._id,
            message: `Your claim for the item: ${lostItem === null || lostItem === void 0 ? void 0 : lostItem.name} has been rejected.`,
            type: 'claimRequestRejected',
            read: false,
            createdAt: new Date(),
        });
        yield (claimPerson === null || claimPerson === void 0 ? void 0 : claimPerson.save());
        res.status(200).json({ message: 'Claim rejected successfully', claim });
    }
    catch (err) {
        res.status(500).json({ error: 'Error rejecting claim', details: err });
    }
});
exports.rejectClaim = rejectClaim;
