import { Request, Response } from 'express';
import  {Claim}  from '../models/claim';
import  LostItem  from '../models/lostItem';
import  {Notification}  from '../models/notification';
import { log } from 'console';
import  User  from '../models/user';

export const submitClaim = async (req: Request, res: Response) => {
  try {
    const { lostItemId, proofText, proofImages } = req.body;
    
    if (!req.user) {
        
        return res.status(401).json({ msg: `uUnauthorized: User not found ${req.user!.id}` });
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
    const notification = new Notification({
      userId: lostItem?.owner.id,
      message: `Someone has claimed the item: ${lostItem?.name}.`,
    });
    
    const owner = await User.findById(lostItem?.owner.id);
    owner?.notifications.push(notification._id as any);
    await owner?.save();

    await notification.save();

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
  
      const lostItem = await LostItem.findById(claim.lostItemId);
      if(!req.user){
        return res.status(401).json({ msg: 'Unauthorized: User not found' });
      }
      if (lostItem?.owner.id.toString() !== req.user.id.toString()) {
        return res.status(403).json({ error: 'You are not authorized to accept this claim' });
      }
      
  
      claim.status = 'accepted';
      await claim.save();
  
      const notification = new Notification({
        userId: claim.userId,
        message: `Your claim for the item: ${lostItem?.name} has been accepted. 
        Please contact the owner to retrieve your item.
        details : 
        owner name : ${req.user.name}
        owner email : ${req.user.email}
        owner phone : ${lostItem?.contactInfo}
        location : ${lostItem?.location.coordinates}
        `,
      });
      
      await notification.save();
      const claimPerson = await User.findById(claim.userId);
      claimPerson?.notifications.push(notification._id as any);
  
      lostItem!.status = 'found';
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
      
      if(!req.user){
        return res.status(401).json({ msg: 'Unauthorized: User not found' });
      }
      const lostItem = await LostItem.findById(claim.lostItemId);
      if (lostItem?.owner.id.toString() !== req.user.id.toString()) {
        return res.status(403).json({ error: 'You are not authorized to reject this claim' });
      }
  
      claim.status = 'rejected';
      await claim.save();
  
      const notification = new Notification({
        userId: claim.userId,
        message: `Your claim for the item: ${lostItem?.name} has been rejected.`,
      });
      await notification.save();
      const claimPerson = await User.findById(claim.userId);
      claimPerson?.notifications.push(notification._id as any);
      res.status(200).json({ message: 'Claim rejected successfully', claim });
    } catch (err) {
      res.status(500).json({ error: 'Error rejecting claim', details: err });
    }
  };
  
  
