import { Request, Response } from 'express';
import { Claim } from '../models/claim';
import LostItem from '../models/lostItem';
import User from '../models/user';


export const submitClaim = async (req: Request, res: Response) => {
  try {
    const { lostItemId, proofText, proofImages } = req.body;
    
    if (!req.user) {
      return res.status(401).json({ msg: `Unauthorized: User not found` });
    }
  
    const userId = req.user.id;

    const claim = new Claim({
      userId,
      lostItemId,
      proofText,
      proofImages,
    });

    await claim.save();

    await LostItem.findByIdAndUpdate(lostItemId, {
      $push: { claims: claim._id },
    });

    const lostItem = await LostItem.findById(lostItemId).populate('owner.id');
    
    const owner = await User.findById(lostItem?.owner.id);
    owner?.notifications.push({
      userId: req.user._id as any,
      itemId: lostItem?._id as any,
      message: `You have a new claim for the item: ${lostItem?.name} from ${req.user.name}`,
      type: 'claimRequest',
      read: false,
      createdAt: new Date(),
    });
    await owner?.save();

    res.status(201).json({ message: 'Claim submitted successfully', claim });
  } catch (err) {
    res.status(500).json({ error: 'Error submitting claim', details: err });
  }
};

export const acceptClaim = async (req: Request, res: Response) => {
  try {
    const { claimId } = req.body;
    const claim = await Claim.findById(claimId);
  
    if (!claim) {
      return res.status(404).json({ error: 'Claim not found' });
    }

    if (!req.user) {
      return res.status(401).json({ msg: 'Unauthorized: User not found' });
    }
  
    const lostItem = await LostItem.findById(claim.lostItemId);
    if (lostItem?.owner.id.toString() !== req.user.id.toString()) {
      return res.status(403).json({ error: 'You are not authorized to accept this claim' });
    }
      
    claim.status = 'accepted';
    await claim.save();

    const claimPerson = await User.findById(claim.userId);
    claimPerson?.notifications.push({
      userId: req.user._id as any,
      itemId: lostItem?._id as any,
      message: `Your claim for the item: ${lostItem?.name} has been accepted.`,
      type: 'claimRequestAccepted',
      read: false,
      createdAt: new Date(),
    });
    await claimPerson?.save();
  
    lostItem!.status = 'found';
    await lostItem!.save();
  
    res.status(200).json({ message: 'Claim accepted successfully', claim });
  } catch (err) {
    res.status(500).json({ error: 'Error accepting claim', details: err });
  }
};

export const rejectClaim = async (req: Request, res: Response) => {
  try {
    const { claimId } = req.body;
    const claim = await Claim.findById(claimId);
  
    if (!claim) {
      return res.status(404).json({ error: 'Claim not found' });
    }

    if (!req.user) {
      return res.status(401).json({ msg: 'Unauthorized: User not found' });
    }
  
    const lostItem = await LostItem.findById(claim.lostItemId);
    if (lostItem?.owner.id.toString() !== req.user.id.toString()) {
      return res.status(403).json({ error: 'You are not authorized to reject this claim' });
    }
  
    claim.status = 'rejected';
    await claim.save();

    const claimPerson = await User.findById(claim.userId);
    claimPerson?.notifications.push({
      userId: req.user._id as any,
      itemId: lostItem?._id as any,
      message: `Your claim for the item: ${lostItem?.name} has been rejected.`,
      type: 'claimRequestRejected',
      read: false,
      createdAt: new Date(),
    });
    await claimPerson?.save();
  
    res.status(200).json({ message: 'Claim rejected successfully', claim });
  } catch (err) {
    res.status(500).json({ error: 'Error rejecting claim', details: err });
  }
};
