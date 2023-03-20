use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_get_aws_credential(
    port_: i64,
    profile: *mut wire_AWSProfile,
    mfa_code: *mut wire_uint_8_list,
) {
    wire_get_aws_credential_impl(port_, profile, mfa_code)
}

#[no_mangle]
pub extern "C" fn wire_s3_list_buckets(port_: i64, profile: *mut wire_AWSProfile) {
    wire_s3_list_buckets_impl(port_, profile)
}

#[no_mangle]
pub extern "C" fn wire_s3_list_objects(
    port_: i64,
    profile: *mut wire_AWSProfile,
    bucket: *mut wire_S3Bucket,
    prefix: *mut wire_uint_8_list,
) {
    wire_s3_list_objects_impl(port_, profile, bucket, prefix)
}

#[no_mangle]
pub extern "C" fn wire_s3_create_folder(
    port_: i64,
    profile: *mut wire_AWSProfile,
    bucket_name: *mut wire_uint_8_list,
    prefix: *mut wire_uint_8_list,
) {
    wire_s3_create_folder_impl(port_, profile, bucket_name, prefix)
}

#[no_mangle]
pub extern "C" fn wire_s3_upload_file(
    port_: i64,
    profile: *mut wire_AWSProfile,
    bucket_name: *mut wire_uint_8_list,
    prefix: *mut wire_uint_8_list,
    file_path: *mut wire_uint_8_list,
) {
    wire_s3_upload_file_impl(port_, profile, bucket_name, prefix, file_path)
}

#[no_mangle]
pub extern "C" fn wire_s3_delete_objects(
    port_: i64,
    profile: *mut wire_AWSProfile,
    bucket_name: *mut wire_uint_8_list,
    prefixes: *mut wire_StringList,
) {
    wire_s3_delete_objects_impl(port_, profile, bucket_name, prefixes)
}

#[no_mangle]
pub extern "C" fn wire_s3_get_objects(
    port_: i64,
    profile: *mut wire_AWSProfile,
    bucket_name: *mut wire_uint_8_list,
    prefixes: *mut wire_StringList,
    config: *mut wire_S3GetObjectConfig,
) {
    wire_s3_get_objects_impl(port_, profile, bucket_name, prefixes, config)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_StringList_0(len: i32) -> *mut wire_StringList {
    let wrap = wire_StringList {
        ptr: support::new_leak_vec_ptr(<*mut wire_uint_8_list>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_aws_profile_0() -> *mut wire_AWSProfile {
    support::new_leak_box_ptr(wire_AWSProfile::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_s_3_bucket_0() -> *mut wire_S3Bucket {
    support::new_leak_box_ptr(wire_S3Bucket::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_s_3_get_object_config_0() -> *mut wire_S3GetObjectConfig {
    support::new_leak_box_ptr(wire_S3GetObjectConfig::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<Vec<String>> for *mut wire_StringList {
    fn wire2api(self) -> Vec<String> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}
impl Wire2Api<AWSProfile> for wire_AWSProfile {
    fn wire2api(self) -> AWSProfile {
        AWSProfile {
            name: self.name.wire2api(),
            region: self.region.wire2api(),
            access_key_id: self.access_key_id.wire2api(),
            secret_access_key: self.secret_access_key.wire2api(),
            session_token: self.session_token.wire2api(),
            mfa_serial: self.mfa_serial.wire2api(),
            expiration: self.expiration.wire2api(),
        }
    }
}

impl Wire2Api<AWSProfile> for *mut wire_AWSProfile {
    fn wire2api(self) -> AWSProfile {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<AWSProfile>::wire2api(*wrap).into()
    }
}
impl Wire2Api<S3Bucket> for *mut wire_S3Bucket {
    fn wire2api(self) -> S3Bucket {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<S3Bucket>::wire2api(*wrap).into()
    }
}
impl Wire2Api<S3GetObjectConfig> for *mut wire_S3GetObjectConfig {
    fn wire2api(self) -> S3GetObjectConfig {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<S3GetObjectConfig>::wire2api(*wrap).into()
    }
}

impl Wire2Api<S3Bucket> for wire_S3Bucket {
    fn wire2api(self) -> S3Bucket {
        S3Bucket {
            name: self.name.wire2api(),
            created_at: self.created_at.wire2api(),
            location: self.location.wire2api(),
        }
    }
}
impl Wire2Api<S3GetObjectConfig> for wire_S3GetObjectConfig {
    fn wire2api(self) -> S3GetObjectConfig {
        S3GetObjectConfig {
            save_dir: self.save_dir.wire2api(),
            zip_for_folder: self.zip_for_folder.wire2api(),
        }
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_StringList {
    ptr: *mut *mut wire_uint_8_list,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_AWSProfile {
    name: *mut wire_uint_8_list,
    region: *mut wire_uint_8_list,
    access_key_id: *mut wire_uint_8_list,
    secret_access_key: *mut wire_uint_8_list,
    session_token: *mut wire_uint_8_list,
    mfa_serial: *mut wire_uint_8_list,
    expiration: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_S3Bucket {
    name: *mut wire_uint_8_list,
    created_at: *mut wire_uint_8_list,
    location: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_S3GetObjectConfig {
    save_dir: *mut wire_uint_8_list,
    zip_for_folder: bool,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_AWSProfile {
    fn new_with_null_ptr() -> Self {
        Self {
            name: core::ptr::null_mut(),
            region: core::ptr::null_mut(),
            access_key_id: core::ptr::null_mut(),
            secret_access_key: core::ptr::null_mut(),
            session_token: core::ptr::null_mut(),
            mfa_serial: core::ptr::null_mut(),
            expiration: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_AWSProfile {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_S3Bucket {
    fn new_with_null_ptr() -> Self {
        Self {
            name: core::ptr::null_mut(),
            created_at: core::ptr::null_mut(),
            location: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_S3Bucket {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_S3GetObjectConfig {
    fn new_with_null_ptr() -> Self {
        Self {
            save_dir: core::ptr::null_mut(),
            zip_for_folder: Default::default(),
        }
    }
}

impl Default for wire_S3GetObjectConfig {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
