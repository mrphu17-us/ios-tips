- (void)getAddressBook()
{///get person from Device
    [self askContactsPermission];
    ABAddressBookRef addressBook = ABAddressBookCreate( );
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    
    for ( int i = 0; i < nPeople; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
        
        
        ///////Phone Number
        ABMultiValueRef contactnumber = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        
        for(CFIndex j = 0; j < ABMultiValueGetCount(contactnumber); j++)
            
        {
            
            CFStringRef contactnumberRef = ABMultiValueCopyValueAtIndex(contactnumber, j);
            
            NSString *contactnumberstr = (__bridge NSString *)contactnumberRef;
            
            CFRelease(contactnumberRef);
            
            NSLog(@"phone number %@ ",contactnumberstr);
        }
        ///////////////Name
        NSString * name = @"";
        
        CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        if (firstName) {
              name = [name stringByAppendingFormat:@"%@",(__bridge NSString *)firstName];
        }
        
        CFStringRef middleName = ABRecordCopyValue(ref, kABPersonMiddleNameProperty);
        if (middleName) {
            name = [name stringByAppendingFormat:@" %@",(__bridge NSString *)middleName];
        }
        
        CFStringRef lastName = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        if (lastName) {
            name = [name stringByAppendingFormat:@" %@",(__bridge NSString *)lastName];
        }
      
        NSLog(@"name %@",name);
        [nameArray addObject:name];
        //////////Image
        CFDataRef thumnail = ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail);
        NSData * data = (__bridge NSData*)thumnail;
        if (!data) {
            data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"]];
        }
        [imageArray addObject:data];
    }
    }
    
    
    
    - (BOOL)askContactsPermission {
    __block BOOL ret = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS6
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            ret = granted;
            dispatch_semaphore_signal(sema);
        });
        if (addressBook) {
            CFRelease(addressBook);
        }
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else { // we're on iOS5 or older
        ret = YES;
    }
    
    return ret;
}
