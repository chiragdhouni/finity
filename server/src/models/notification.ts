import mongoose, { Schema, Document } from 'mongoose';

interface INotification extends Document {
  userId: mongoose.Types.ObjectId;
  message: string;
  read: boolean;
}

const NotificationSchema: Schema = new Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  message: { type: String, required: true },
  read: { type: Boolean, default: false },
}, {
  timestamps: true,
});

export const Notification = mongoose.model<INotification>('Notification', NotificationSchema);
