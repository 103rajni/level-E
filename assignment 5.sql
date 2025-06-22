CREATE PROCEDURE UpdateSubjectAllotments
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StudentID VARCHAR(50);
    DECLARE @RequestedSubjectID VARCHAR(50);
    DECLARE @CurrentSubjectID VARCHAR(50);

    DECLARE request_cursor CURSOR FOR
        SELECT StudentID, SubjectID FROM SubjectRequest;

    OPEN request_cursor;
    FETCH NEXT FROM request_cursor INTO @StudentID, @RequestedSubjectID;
    WHILE @@FETCH_STATUS = 0
    BEGIN
     IF EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentID = @StudentID)
    BEGIN
          
        SELECT @CurrentSubjectID = SubjectID
            FROM SubjectAllotments
            WHERE StudentID = @StudentID AND Is_Valid = 1;

            
            IF @CurrentSubjectID <> @RequestedSubjectID
            BEGIN
               
                UPDATE SubjectAllotments
                SET Is_Valid = 0
                WHERE StudentID = @StudentID;

               
                INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
                VALUES (@StudentID, @RequestedSubjectID, 1);
            END
           
        END
        ELSE
        BEGIN
            
            INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
            VALUES (@StudentID, @RequestedSubjectID, 1);
        END

        FETCH NEXT FROM request_cursor INTO @StudentID, @RequestedSubjectID;
    END

    CLOSE request_cursor;
    DEALLOCATE request_cursor;

END;
