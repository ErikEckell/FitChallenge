# FitChallenge – Basic Data Model

![Data Model](DataModel.png)

## Main Data Flow

1. **User Registration and Roles:**  
   Users (`users`) create accounts. Roles determine permissions: participant, creator, or admin.

2. **Challenges and Participation:**  
   - Creators can create challenges (`challenges`).  
   - Users join challenges (`participations`), tracking their progress and status.

3. **Activity Logging:**  
   - Each activity is recorded as a `progress_entry` linked to an `exercise`.  
   - Points are automatically calculated based on the exercise metrics.

4. **Global Statistics:**  
   - Each entry updates `participations.total_points` and `user_statistics` (total points, accumulated metrics, completed challenges).

5. **Badges and Rankings:**  
   - Badges (`user_badges`) are awarded when conditions in `badges.condition` are met.  
   - Points and statistics generate both challenge-specific and global leaderboards.
