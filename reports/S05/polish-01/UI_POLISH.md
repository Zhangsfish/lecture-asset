# UI polish

Normal selection and review use one short helper. JPEG-complete remains an explicit user transition to Generate ZIP + PDF. Archive state replaces the JPEG phase heading; the ready screen has one Files ready heading and a short save reminder. ZIP save is primary; PDF view/share are secondary. The visible Keep Photos, Clear App Files action no longer uses a disclosure, and is disabled during archive/export mutation.

The App-only action still calls only `ProcessingModel.discardWorkCopyKeepingPhotos()` after its separate confirmation. The confirmation explicitly names local JPEG/ZIP/PDF/OCR/recovery files, warns unsaved files cannot be recovered, and states Photos originals are kept. No PhotoKit call was added to this path. ZIP identity, exact source set, external-save confirmation and fresh source-delete gates are unchanged.
