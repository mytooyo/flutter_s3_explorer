#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_AWSProfile {
  struct wire_uint_8_list *name;
  struct wire_uint_8_list *region;
  struct wire_uint_8_list *access_key_id;
  struct wire_uint_8_list *secret_access_key;
  struct wire_uint_8_list *session_token;
  struct wire_uint_8_list *mfa_serial;
  struct wire_uint_8_list *expiration;
} wire_AWSProfile;

typedef struct wire_S3Bucket {
  struct wire_uint_8_list *name;
  struct wire_uint_8_list *created_at;
  struct wire_uint_8_list *location;
} wire_S3Bucket;

typedef struct wire_StringList {
  struct wire_uint_8_list **ptr;
  int32_t len;
} wire_StringList;

typedef struct wire_S3GetObjectConfig {
  struct wire_uint_8_list *save_dir;
  bool zip_for_folder;
} wire_S3GetObjectConfig;

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_get_aws_credential(int64_t port_,
                             struct wire_AWSProfile *profile,
                             struct wire_uint_8_list *mfa_code);

void wire_s3_list_buckets(int64_t port_, struct wire_AWSProfile *profile);

void wire_s3_list_objects(int64_t port_,
                          struct wire_AWSProfile *profile,
                          struct wire_S3Bucket *bucket,
                          struct wire_uint_8_list *prefix);

void wire_s3_create_folder(int64_t port_,
                           struct wire_AWSProfile *profile,
                           struct wire_uint_8_list *bucket_name,
                           struct wire_uint_8_list *prefix);

void wire_s3_upload_file(int64_t port_,
                         struct wire_AWSProfile *profile,
                         struct wire_uint_8_list *bucket_name,
                         struct wire_uint_8_list *prefix,
                         struct wire_uint_8_list *file_path);

void wire_s3_delete_objects(int64_t port_,
                            struct wire_AWSProfile *profile,
                            struct wire_uint_8_list *bucket_name,
                            struct wire_StringList *prefixes);

void wire_s3_get_objects(int64_t port_,
                         struct wire_AWSProfile *profile,
                         struct wire_uint_8_list *bucket_name,
                         struct wire_StringList *prefixes,
                         struct wire_S3GetObjectConfig *config);

struct wire_StringList *new_StringList_0(int32_t len);

struct wire_AWSProfile *new_box_autoadd_aws_profile_0(void);

struct wire_S3Bucket *new_box_autoadd_s_3_bucket_0(void);

struct wire_S3GetObjectConfig *new_box_autoadd_s_3_get_object_config_0(void);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_get_aws_credential);
    dummy_var ^= ((int64_t) (void*) wire_s3_list_buckets);
    dummy_var ^= ((int64_t) (void*) wire_s3_list_objects);
    dummy_var ^= ((int64_t) (void*) wire_s3_create_folder);
    dummy_var ^= ((int64_t) (void*) wire_s3_upload_file);
    dummy_var ^= ((int64_t) (void*) wire_s3_delete_objects);
    dummy_var ^= ((int64_t) (void*) wire_s3_get_objects);
    dummy_var ^= ((int64_t) (void*) new_StringList_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_aws_profile_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_s_3_bucket_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_s_3_get_object_config_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
