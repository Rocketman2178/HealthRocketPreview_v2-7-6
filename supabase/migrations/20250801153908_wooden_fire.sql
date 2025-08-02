/*
  # Add feedback column to users table

  1. New Columns
    - `feedback` (boolean, default false)
      - Indicates if user has submitted any support messages

  2. Trigger Function
    - Automatically updates feedback status when support messages change
    - Sets to true if user has any support messages (any category)
    - Sets to false if user has no support messages

  3. Initial Data Population
    - Sets feedback = true for existing users with support messages
*/

-- Add feedback column to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS feedback boolean DEFAULT false;

-- Create trigger function to update feedback status
CREATE OR REPLACE FUNCTION update_user_feedback_status()
RETURNS TRIGGER AS $$
BEGIN
  -- Handle INSERT and UPDATE
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    -- Set feedback = true for the user
    UPDATE users 
    SET feedback = true 
    WHERE id = NEW.user_id;
    
    RETURN NEW;
  END IF;
  
  -- Handle DELETE
  IF TG_OP = 'DELETE' THEN
    -- Check if user still has any support messages
    UPDATE users 
    SET feedback = (
      EXISTS (
        SELECT 1 FROM support_messages 
        WHERE user_id = OLD.user_id
      )
    )
    WHERE id = OLD.user_id;
    
    RETURN OLD;
  END IF;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS update_user_feedback_trigger ON support_messages;

-- Create trigger on support_messages table
CREATE TRIGGER update_user_feedback_trigger
  AFTER INSERT OR UPDATE OR DELETE ON support_messages
  FOR EACH ROW EXECUTE FUNCTION update_user_feedback_status();

-- Update existing users who have support messages
UPDATE users 
SET feedback = true 
WHERE id IN (
  SELECT DISTINCT user_id 
  FROM support_messages
);