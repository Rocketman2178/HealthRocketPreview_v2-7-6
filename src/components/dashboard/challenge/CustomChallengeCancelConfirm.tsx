import React from 'react';
import { AlertTriangle, X } from 'lucide-react';

interface CustomChallengeCancelConfirmProps {
  onConfirm: () => void;
  onClose: () => void;
}

export function CustomChallengeCancelConfirm({ onConfirm, onClose }: CustomChallengeCancelConfirmProps) {
  return (
    <div className="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-gray-800 rounded-lg max-w-md w-full p-4 space-y-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <AlertTriangle className="text-orange-500" size={24} />
            <h3 className="text-lg font-semibold text-white">Cancel Custom Challenge</h3>
          </div>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-300"
          >
            <X size={20} />
          </button>
        </div>
        
        <div className="space-y-3">
          <p className="text-gray-300">Are you sure you want to cancel this custom challenge?</p>
          <p className="text-sm text-gray-400">
            Your progress will be lost and you'll need to create a new custom challenge if you want to continue. 
            This action cannot be undone.
          </p>
          <div className="bg-orange-500/10 border border-orange-500/20 p-3 rounded-lg">
            <p className="text-sm text-orange-400">
              Note: Canceling this challenge will not affect your ability to create new custom challenges.
            </p>
          </div>
        </div>

        <div className="flex justify-end gap-3">
          <button
            onClick={onClose}
            className="px-4 py-2 text-sm text-gray-400 hover:text-white transition-colors"
          >
            Keep Challenge
          </button>
          <button
            onClick={() => {
              onConfirm();
              onClose();
            }}
            className="px-4 py-2 text-sm bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors"
          >
            Confirm Cancel
          </button>
        </div>
      </div>
    </div>
  );
}