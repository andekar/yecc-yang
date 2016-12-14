Nonterminals module_stmt module_header_stmts module_header_stmt module_stmts linkage_stmts linkage_stmt prefix_stmt import_stmt include_stmt include_stmt_cont revision_date_stmts revision_date_stmt body_stmts body_stmt typedef_stmt typedef_stmts typedef_stmtp type_stmt type_stmt_cont type_body_stmts numerical_restrictions range_stmt range_stmt_cont range_stmts range_stmtp error_message_stmt error_app_tag_stmt description_stmt reference_stmt decimal64_specification fraction_digits_stmt string_restrictions string_restriction length_stmt length_stmt_cont length_stmts length_stmtp pattern_stmt pattern_stmt_cont pattern_stmts pattern_stmtp units_stmt default_stmt status_stmt data_def_stmt container_stmt container_stmt_cont container_stmts container_stmtp when_stmt when_stmts when_stmtp when_stmt_cont if_feature_stmt must_stmt must_stmt_cont must_stmtp must_stmts presence_stmt config_stmt grouping_stmt grouping_stmtp grouping_stmts grouping_stmt_cont leaf_stmt leaf_stmts leaf_stmtp mandatory_stmt leaf_list_stmt leaf_list_stmts leaf_list_stmtp min_elements_stmt max_elements_stmt ordered_by_stmt list_stmtp list_stmts list_stmt unique_stmt key_stmt key_arg_strs true_or_false enum_specification leafref_specification identityref_specification instance_identifier_specification bits_specification union_specification enum_stmt enum_stmt_cont enum_stmts enum_stmtp value_stmt status_arg bit_stmt bit_stmt_cont bit_stmts bit_stmtp position_stmt base_stmt require_instance_stmt path_stmt string_or_int_or_float submodule_stmt revision_stmt revision_stmt_cont revision_stmts revision_stmtp meta_stmts meta_stmt contact_stmt organization_stmt submodule_header_stmts belongs_to_stmt yang_version_stmt mod_or_submod augment_stmt augment_stmts augment_stmtp case_stmt case_stmt_cont case_stmtp case_stmts choice_stmt choice_stmtp choice_stmts choice_stmt_cont identity_stmt_cont identity_stmt identity_stmts identity_stmtp module_header_stmtsc.

Terminals  module ident ';' '{' '}' namespace string 'yang-version' prefix import include 'revision-date' typedef type range 'error-message' 'error-app-tag' description reference 'fraction-digits' length pattern units default status container 'when' 'if-feature' must presence config grouping leaf mandatory 'leaf-list' 'max-elements' 'min-elements' 'ordered-by' integer list unique key true false enum current obsolete value deprecated bit position base 'require-instance' path submodule revision contact organization 'belongs-to' date augment 'case' choice string_pattern identity float.

Rootsymbol mod_or_submod.

mod_or_submod -> module_stmt : '$1'.
mod_or_submod -> submodule_stmt : '$1'.

%% module-stmt         = optsep module-keyword sep identifier-arg-str
%%                       optsep
%%                       "{" stmtsep
%%                           module-header-stmts
%%                           linkage-stmts
%%                           meta-stmts
%%                           revision-stmts
%%                           body-stmts
%%                       "}" optsep
module_stmt -> module ident '{' module_stmts '}' : {modname, extract_token('$2'), '$4'}.

module_stmts -> module_header_stmts
                    linkage_stmts
                    meta_stmts
                    revision_stmt
                    body_stmts

                    : {{header_stmts, '$1'}
                       ,{linkage_stmts, '$2'}
                       ,{meta_stmts, '$3'}
                       ,{revision_stmt, '$4'}
                       ,{body_stmts, '$5'}
                      }.

%% submodule-stmt      = optsep submodule-keyword sep identifier-arg-str
%%                       optsep
%%                       "{" stmtsep
%%                           submodule-header-stmts
%%                           linkage-stmts
%%                           meta-stmts
%%                           revision-stmts
%%                           body-stmts
%%                       "}" optsep
submodule_stmt -> submodule ident '{' submodule_header_stmts linkage_stmts meta_stmts revision_stmt body_stmts '}' : {submodule, extract_token('$2'),
                                                                                                                       {sub_header_stmts, '$4'},
                                                                                                                       {linkage_stmts, '$5'},
                                                                                                                       {meta_stmts, '$6'},
                                                                                                                       {revision_stmts, '$7'},
                                                                                                                       {body_stmts, '$8'}
                                                                                                                      }.

%% revision-stmt       = revision-keyword sep revision-date optsep
%%                       (";" /
%%                        "{" stmtsep
%%                            [description-stmt stmtsep]
%%                            [reference-stmt stmtsep]
%%                        "}")
revision_stmt -> revision date revision_stmt_cont : [{revision, extract_token('$2'), '$3'}].
revision_stmt -> '$empty' : [].

revision_stmt_cont -> ';' : [].
revision_stmt_cont -> '{' revision_stmts '}' : '$2'.

revision_stmts -> '$empty' : [].
revision_stmts -> revision_stmtp revision_stmts : ['$1'|'$2'].

revision_stmtp -> description_stmt : '$1'.
revision_stmtp -> reference_stmt   : '$1'.


%% meta-stmts          = ;; these stmts can appear in any order
%%                       [organization-stmt stmtsep]
%%                       [contact-stmt stmtsep]
%%                       [description-stmt stmtsep]
%%                       [reference-stmt stmtsep]
meta_stmts -> '$empty' : [].
meta_stmts -> meta_stmt meta_stmts : ['$1'|'$2'].

meta_stmt -> organization_stmt : '$1'.
meta_stmt -> contact_stmt      : '$1'.
meta_stmt -> description_stmt  : '$1'.
meta_stmt -> reference_stmt    : '$1'.

%% contact-stmt        = contact-keyword sep string optsep stmtend
contact_stmt -> contact string ';' : {contact, extract_token('$2')}.

%% organization-stmt   = organization-keyword sep string
%%                       optsep stmtend
organization_stmt -> organization string ';' : {organization, extract_token('$2')}.

%% submodule-header-stmts =
%%                       ;; these stmts can appear in any order
%%                       [yang-version-stmt stmtsep]
%%                        belongs-to-stmt stmtsep
submodule_header_stmts -> yang_version_stmt : '$1'.
submodule_header_stmts -> belongs_to_stmt   : '$1'.

%% belongs-to-stmt     = belongs-to-keyword sep identifier-arg-str
%%                       optsep
%%                       "{" stmtsep
%%                           prefix-stmt stmtsep
%%                       "}"
belongs_to_stmt -> 'belongs-to' ident '{' prefix_stmt '}' : {'belongs-to', extract_token('$2'), '$4'}.

%% yang-version-stmt   = yang-version-keyword sep yang-version-arg-str
%%                       optsep stmtend
yang_version_stmt -> 'yang-version' integer ';' : {'yang-version', integer_to_list(extract_token('$2'))}.

%% module-header-stmts = ;; these stmts can appear in any order
%%                       [yang-version-stmt stmtsep]
%%                        namespace-stmt stmtsep
%%                        prefix-stmt stmtsep
module_header_stmts -> module_header_stmt module_header_stmtsc : ['$1'|'$2'].

module_header_stmtsc -> '$empty' : [].
module_header_stmtsc -> module_header_stmt module_header_stmtsc : ['$1'|'$2'].

%%yang-version-keyword sep yang-version-arg-str optsep stmtend
%% todo now we skip several
module_header_stmt -> 'yang-version' ident ';' : {'yang-version', '$2'} .
%%  namespace-stmt      = namespace-keyword sep uri-str optsep stmtend
module_header_stmt -> namespace string ';' : {namespace,extract_token('$2')}.
%%prefix-stmt         = prefix-keyword sep prefix-arg-str optsep stmtend
module_header_stmt -> prefix_stmt : {'$1'}.

%%
%% linkage STMTS
%%
%% linkage-stmts       = ;; these stmts can appear in any order
%%                          *(import-stmt stmtsep)
%%                          *(include-stmt stmtsep)
linkage_stmts -> '$empty' : [].
linkage_stmts -> linkage_stmt linkage_stmts : ['$1'|'$2'].

linkage_stmt -> import_stmt : '$1'.
linkage_stmt -> include_stmt : '$1'.

%% body-stmts          = *((extension-stmt /
%%                          feature-stmt /
%%                          identity-stmt /
%%                          typedef-stmt /
%%                          grouping-stmt /
%%                          data-def-stmt /
%%                          augment-stmt /
%%                          rpc-stmt /
%%                          notification-stmt /
%%                          deviation-stmt) stmtsep)
body_stmts ->'$empty' : [].
body_stmts -> body_stmt body_stmts : ['$1'|'$2'].

%body_stmt -> feature_stmt      : '$1'.
body_stmt -> identity_stmt     : '$1'.
body_stmt -> typedef_stmt      : '$1'.
body_stmt -> grouping_stmt     : '$1'.
body_stmt -> data_def_stmt     : '$1'.
body_stmt -> augment_stmt      : '$1'.
%% body_stmt -> rpc-stmt          : '$1'.
%% body_stmt -> notification_stmt : '$1'.
%% body_stmt -> deviation_stmt    : '$1'.

%% identity-stmt       = identity-keyword sep identifier-arg-str optsep
%%                       (";" /
%%                        "{" stmtsep
%%                            ;; these stmts can appear in any order
%%                            [base-stmt stmtsep]
%%                            [status-stmt stmtsep]
%%                            [description-stmt stmtsep]
%%                            [reference-stmt stmtsep]
%%                        "}")
identity_stmt -> identity ident identity_stmt_cont : {identity, extract_token('$2')}.

identity_stmt_cont -> ';' : [].
identity_stmt_cont -> '{' identity_stmts '}' : '$2'.

identity_stmts -> '$empty' : [].
identity_stmts -> identity_stmtp identity_stmts : ['$1'|'$2'].

identity_stmtp -> base_stmt        : '$1'.
identity_stmtp -> status_stmt      : '$1'.
identity_stmtp -> description_stmt : '$1'.
identity_stmtp -> reference_stmt   : '$1'.

%% augment-stmt        = augment-keyword sep augment-arg-str optsep
%%                       "{" stmtsep
%%                           ;; these stmts can appear in any order
%%                           [when-stmt stmtsep]
%%                           *(if-feature-stmt stmtsep)
%%                           [status-stmt stmtsep]
%%                           [description-stmt stmtsep]
%%                           [reference-stmt stmtsep]
%%                           1*((data-def-stmt stmtsep) /
%%                              (case-stmt stmtsep))
%%                        "}"
augment_stmt -> augment ident '{' augment_stmts '}' : {augment, extract_token('$2'), '$4'}.

augment_stmts ->'$empty' : [].
augment_stmts -> augment_stmtp augment_stmts : ['$1'|'$2'].

augment_stmtp -> when_stmt        : '$1'.
augment_stmtp -> if_feature_stmt  : '$1'.
augment_stmtp -> status_stmt      : '$1'.
augment_stmtp -> description_stmt : '$1'.
augment_stmtp -> reference_stmt   : '$1'.
augment_stmtp -> data_def_stmt    : '$1'.
augment_stmtp -> case_stmt        : '$1'.

%% case-stmt           = case-keyword sep identifier-arg-str optsep
%%                          (";" /
%%                           "{" stmtsep
%%                               ;; these stmts can appear in any order
%%                               [when-stmt stmtsep]
%%                               *(if-feature-stmt stmtsep)
%%                               [status-stmt stmtsep]
%%                               [description-stmt stmtsep]
%%                               [reference-stmt stmtsep]
%%                               *(data-def-stmt stmtsep)
%%                           "}")
case_stmt -> 'case' ident case_stmt_cont : {'case', extract_token('$2'), '$3'}.

case_stmt_cont -> ';' : [].
case_stmt_cont -> '{' case_stmts '}' : '$2'.

case_stmts -> '$empty' : [].
case_stmts -> case_stmtp case_stmts : ['$1'|'$2'].

case_stmtp -> when_stmt        : '$1'.
case_stmtp -> if_feature_stmt  : '$1'.
case_stmtp -> status_stmt      : '$1'.
case_stmtp -> description_stmt : '$1'.
case_stmtp -> reference_stmt   : '$1'.
case_stmtp -> data_def_stmt    : '$1'.

%% data-def-stmt       = container-stmt /
%%                       leaf-stmt /
%%                       leaf-list-stmt /
%%                       list-stmt /
%%                       choice-stmt /
%%                       anyxml-stmt /
%%                       uses-stmt
data_def_stmt -> container_stmt : '$1'.
data_def_stmt -> leaf_stmt      : '$1'.
data_def_stmt -> leaf_list_stmt : '$1'.
data_def_stmt -> list_stmt      : '$1'.
data_def_stmt -> choice_stmt    : '$1'.
%% data_def_stmt -> anyxml_stmt    : '$1'.
%% data_def_stmt -> uses_stmt      : '$1'.

%% choice-stmt         = choice-keyword sep identifier-arg-str optsep
%%                       (";" /
%%                        "{" stmtsep
%%                            ;; these stmts can appear in any order
%%                            [when-stmt stmtsep]
%%                            *(if-feature-stmt stmtsep)
%%                            [default-stmt stmtsep]
%%                            [config-stmt stmtsep]
%%                            [mandatory-stmt stmtsep]
%%                            [status-stmt stmtsep]
%%                            [description-stmt stmtsep]
%%                            [reference-stmt stmtsep]
%%                            *((short-case-stmt / case-stmt) stmtsep)
%%                        "}")
choice_stmt -> choice ident choice_stmt_cont : {choice, extract_token('$2'), '$3'}.

choice_stmt_cont -> ';' : [].
choice_stmt_cont -> '{' choice_stmts '}' : '$2'.

choice_stmts -> '$empty' : [].
choice_stmts -> choice_stmtp choice_stmts : ['$1'|'$2'].

choice_stmtp -> when_stmt        : '$1'.
choice_stmtp -> if_feature_stmt  : '$1'.
choice_stmtp -> default_stmt     : '$1'.
choice_stmtp -> config_stmt      : '$1'.
choice_stmtp -> mandatory_stmt   : '$1'.
choice_stmtp -> status_stmt      : '$1'.
choice_stmtp -> description_stmt : '$1'.
choice_stmtp -> reference_stmt   : '$1'.
%choice_stmtp -> short_case_stmt  : '$1'.
choice_stmtp -> case_stmt        : '$1'.


%% list-stmt           = list-keyword sep identifier-arg-str optsep
%%                       "{" stmtsep
%%                           ;; these stmts can appear in any order
%%                           [when-stmt stmtsep]
%%                           *(if-feature-stmt stmtsep)
%%                           *(must-stmt stmtsep)
%%                           [key-stmt stmtsep]
%%                           *(unique-stmt stmtsep)
%%                           [config-stmt stmtsep]
%%                           [min-elements-stmt stmtsep]
%%                           [max-elements-stmt stmtsep]
%%                           [ordered-by-stmt stmtsep]
%%                           [status-stmt stmtsep]
%%                           [description-stmt stmtsep]
%%                           [reference-stmt stmtsep]
%%                           *((typedef-stmt /
%%                              grouping-stmt) stmtsep)
%%                           1*(data-def-stmt stmtsep)
%%                        "}"
list_stmt -> list ident '{' list_stmts '}' : {list, extract_token('$2'), '$4'}.

list_stmts -> '$empty' : [].
list_stmts -> list_stmtp list_stmts : ['$1'|'$2'].

list_stmtp -> when_stmt         : '$1'.
list_stmtp -> if_feature_stmt   : '$1'.
list_stmtp -> must_stmt         : '$1'.
list_stmtp -> key_stmt          : '$1'.
list_stmtp -> unique_stmt       : '$1'.
list_stmtp -> config_stmt       : '$1'.
list_stmtp -> min_elements_stmt : '$1'.
list_stmtp -> max_elements_stmt : '$1'.
list_stmtp -> ordered_by_stmt   : '$1'.
list_stmtp -> status_stmt       : '$1'.
list_stmtp -> description_stmt  : '$1'.
list_stmtp -> reference_stmt    : '$1'.
list_stmtp -> typedef_stmt      : '$1'.
list_stmtp -> grouping_stmt     : '$1'.
list_stmtp -> data_def_stmt     : '$1'.

% unique-stmt         = unique-keyword sep unique-arg-str stmtend
unique_stmt -> unique ident ';' : {unique, extract_token('$2')}.

% key-stmt            = key-keyword sep key-arg-str stmtend
key_stmt -> key key_arg_strs ';' : {key, '$2'}.

%% key_arg_strs -> '$empty' : [].
%% key_arg_strs -> key_arg_str key_arg_strs: ['$1'|'$2'].

%% key_arg_str -> string_or_ident : '$1'.

key_arg_strs -> string : lists:map(fun(V) -> list_to_atom(V) end, string:tokens(extract_token('$1'), " ")).
key_arg_strs -> ident  : extract_token('$1').

%% leaf-list-stmt      = leaf-list-keyword sep identifier-arg-str optsep
%%                       "{" stmtsep
%%                           ;; these stmts can appear in any order
%%                           [when-stmt stmtsep]
%%                           *(if-feature-stmt stmtsep)
%%                           type-stmt stmtsep
%%                           [units-stmt stmtsep]
%%                           *(must-stmt stmtsep)
%%                           [config-stmt stmtsep]
%%                           [min-elements-stmt stmtsep]
%%                           [max-elements-stmt stmtsep]
%%                           [ordered-by-stmt stmtsep]
%%                           [status-stmt stmtsep]
%%                           [description-stmt stmtsep]
%%                           [reference-stmt stmtsep]
%%                        "}"
leaf_list_stmt -> 'leaf-list' ident '{' leaf_list_stmts '}' : {'leaf-list', extract_token('$2'), '$4'}.

leaf_list_stmts ->'$empty' : [].
leaf_list_stmts -> leaf_list_stmtp leaf_list_stmts : ['$1'|'$2'].


leaf_list_stmtp -> when_stmt         : '$1'.
leaf_list_stmtp -> if_feature_stmt   : '$1'.
leaf_list_stmtp -> type_stmt         : '$1'.
leaf_list_stmtp -> units_stmt        : '$1'.
leaf_list_stmtp -> must_stmt         : '$1'.
leaf_list_stmtp -> config_stmt       : '$1'.
leaf_list_stmtp -> min_elements_stmt : '$1'.
leaf_list_stmtp -> max_elements_stmt : '$1'.
leaf_list_stmtp -> ordered_by_stmt   : '$1'.
leaf_list_stmtp -> status_stmt       : '$1'.
leaf_list_stmtp -> description_stmt  : '$1'.
leaf_list_stmtp -> reference_stmt    : '$1'.

%% ordered-by-stmt     = ordered-by-keyword sep
%%                       ordered-by-arg-str stmtend
ordered_by_stmt -> 'ordered-by' ident ';' : {'ordered-by', extract_token('$2')}.

%% min-elements-stmt   = min-elements-keyword sep
%%                       min-value-arg-str stmtend
min_elements_stmt -> 'min-elements' 'integer' ';' : {'min-elements', extract_token('$2')}.

%% max-elements-stmt   = max-elements-keyword sep
%%                       max-value-arg-str stmtend
max_elements_stmt -> 'max-elements' 'integer' ';' : {'max-elements', extract_token('$2')}.

%% leaf-stmt           = leaf-keyword sep identifier-arg-str optsep
%%                       "{" stmtsep
%%                           ;; these stmts can appear in any order
%%                           [when-stmt stmtsep]
%%                           *(if-feature-stmt stmtsep)
%%                           type-stmt stmtsep
%%                           [units-stmt stmtsep]
%%                           *(must-stmt stmtsep)
%%                           [default-stmt stmtsep]
%%                           [config-stmt stmtsep]
%%                           [mandatory-stmt stmtsep]
%%                           [status-stmt stmtsep]
%%                           [description-stmt stmtsep]
%%                           [reference-stmt stmtsep]
%%                        "}"
leaf_stmt -> leaf ident '{' leaf_stmts '}' : {leaf, extract_token('$2'), '$4'}.

leaf_stmts -> '$empty' : [].
leaf_stmts -> leaf_stmtp leaf_stmts : ['$1'|'$2'].

leaf_stmtp -> when_stmt        : '$1'.
leaf_stmtp -> if_feature_stmt  : '$1'.
leaf_stmtp -> type_stmt        : '$1'.
leaf_stmtp -> units_stmt       : '$1'.
leaf_stmtp -> must_stmt        : '$1'.
leaf_stmtp -> default_stmt     : '$1'.
leaf_stmtp -> config_stmt      : '$1'.
leaf_stmtp -> mandatory_stmt   : '$1'.
leaf_stmtp -> status_stmt      : '$1'.
leaf_stmtp -> description_stmt : '$1'.
leaf_stmtp -> reference_stmt   : '$1'.

%% mandatory-stmt      = mandatory-keyword sep
%%                       mandatory-arg-str stmtend
mandatory_stmt -> mandatory true_or_false ';' : {mandatory, '$2'}.

%% container-stmt      = container-keyword sep identifier-arg-str optsep
%%                       (";" /
%%                        "{" stmtsep
%%                            ;; these stmts can appear in any order
%%                            [when-stmt stmtsep]
%%                            *(if-feature-stmt stmtsep)
%%                            *(must-stmt stmtsep)
%%                            [presence-stmt stmtsep]
%%                            [config-stmt stmtsep]
%%                            [status-stmt stmtsep]
%%                            [description-stmt stmtsep]
%%                            [reference-stmt stmtsep]
%%                            *((typedef-stmt /
%%                               grouping-stmt) stmtsep)
%%                            *(data-def-stmt stmtsep)
%%                        "}")
container_stmt -> container ident container_stmt_cont : {container, extract_token('$2'), '$3'}.

container_stmt_cont -> ';' : [].
container_stmt_cont -> '{' container_stmts '}' : '$2'.

container_stmts -> '$empty' : [].
container_stmts -> container_stmtp container_stmts : ['$1'|'$2'].

%% note all these will allow lists so we need to check this later...
container_stmtp -> when_stmt : '$1'.
container_stmtp -> if_feature_stmt : '$1'.
container_stmtp -> must_stmt : '$1'.
container_stmtp -> presence_stmt : '$1'.
container_stmtp -> config_stmt : '$1'.
container_stmtp -> status_stmt : '$1'.
container_stmtp -> description_stmt : '$1'.
container_stmtp -> reference_stmt : '$1'.
%% todo not sure what to do here..
container_stmtp -> typedef_stmt : '$1'.
container_stmtp -> grouping_stmt : '$1'.
container_stmtp -> data_def_stmt : '$1'.

%% grouping-stmt       = grouping-keyword sep identifier-arg-str optsep
%%                       (";" /
%%                        "{" stmtsep
%%                            ;; these stmts can appear in any order
%%                            [status-stmt stmtsep]
%%                            [description-stmt stmtsep]
%%                            [reference-stmt stmtsep]
%%                            *((typedef-stmt /
%%                               grouping-stmt) stmtsep)
%%                            *(data-def-stmt stmtsep)
%%                        "}")
grouping_stmt -> grouping ident grouping_stmt_cont : {grouping, extract_token('$2'), '$3'}.

grouping_stmt_cont -> ';' : [].
grouping_stmt_cont -> '{' grouping_stmts '}' : '$2'.

grouping_stmts -> '$empty' : [].
grouping_stmts -> grouping_stmtp grouping_stmts : ['$1'|'$2'].

grouping_stmtp -> status_stmt      : '$1'.
grouping_stmtp -> description_stmt : '$1'.
grouping_stmtp -> reference_stmt   : '$1'.
%% todo not sure what to do here...
grouping_stmtp -> typedef_stmt     : '$1'.
grouping_stmtp -> grouping_stmt    : '$1'.
grouping_stmtp -> data_def_stmt    : '$1'.



%% config-stmt         = config-keyword sep
%%                       config-arg-str stmtend
config_stmt -> config true_or_false ';' : {config, '$2'}.

true_or_false -> true  : true.
true_or_false -> false : false.

%% presence-stmt       = presence-keyword sep string stmtend
presence_stmt -> presence string ';' : {presence, extract_token('$2')}.

%% must-stmt           = must-keyword sep string optsep
%%                       (";" /
%%                        "{" stmtsep
%%                            ;; these stmts can appear in any order
%%                            [error-message-stmt stmtsep]
%%                            [error-app-tag-stmt stmtsep]
%%                            [description-stmt stmtsep]
%%                            [reference-stmt stmtsep]
%%                         "}")
must_stmt -> must string must_stmt_cont : {must, extract_token('$2'), '$3'}.

must_stmt_cont -> ';' : [].
must_stmt_cont -> '{' must_stmts '}' : '$2'.

must_stmts -> '$empty' : [].
must_stmts -> must_stmtp must_stmts :  ['$1'|'$2'].

must_stmtp -> error_message_stmt : '$1'.
must_stmtp -> error_app_tag_stmt : '$1'.
must_stmtp -> description_stmt   : '$1'.
must_stmtp -> reference_stmt     : '$1'.



%% if-feature-stmt     = if-feature-keyword sep identifier-ref-arg-str
%%                       optsep stmtend
%% TODO this probably is broken
if_feature_stmt -> 'if-feature' string ';' : {'if-feature', extract_token('$2')}.

%% when-stmt           = when-keyword sep string optsep
%%                          (";" /
%%                           "{" stmtsep
%%                             ;; these stmts can appear in any order
%%                             [description-stmt stmtsep]
%%                               [reference-stmt stmtsep]
%%                            "}")
when_stmt -> 'when' string when_stmt_cont : {'when', extract_token('$2'), '$3'}.

when_stmt_cont -> ';' : [].
when_stmt_cont -> '{' when_stmts '}' : '$2'.

when_stmts -> '$empty' : [].
when_stmts -> when_stmtp when_stmts : ['$1'|'$2'].

when_stmtp -> description_stmt : '$1'.
when_stmtp -> reference_stmt   : '$1'.

%% typedef-stmt        = typedef-keyword sep identifier-arg-str optsep
%%                          "{" stmtsep
%%                              ;; these stmts can appear in any order
%%                              type-stmt stmtsep
%%                              [units-stmt stmtsep]
%%                              [default-stmt stmtsep]
%%                              [status-stmt stmtsep]
%%                              [description-stmt stmtsep]
%%                              [reference-stmt stmtsep]
%%                           "}"
typedef_stmt -> typedef ident '{' typedef_stmts '}' : {typedef, extract_token('$2'), '$4'}.

typedef_stmts -> '$empty' : [].
typedef_stmts -> typedef_stmtp typedef_stmts : ['$1'|'$2'].

typedef_stmtp -> type_stmt : '$1'.
typedef_stmtp -> units_stmt : '$1'.
typedef_stmtp -> default_stmt : '$1'.
typedef_stmtp -> status_stmt : '$1'.
typedef_stmtp -> description_stmt : '$1'.
typedef_stmtp -> reference_stmt : '$1'.

%% type-stmt           = type-keyword sep identifier-ref-arg-str optsep
%%                          (";" /
%%                           "{" stmtsep
%%                               type-body-stmts
%%                           "}")
type_stmt -> type ident type_stmt_cont : {type, extract_token('$2'), '$3'}.
type_stmt_cont -> ';' : [].
type_stmt_cont -> '{' type_body_stmts '}' : '$2'.

%% type-body-stmts     = numerical-restrictions /
%%                          decimal64-specification /
%%                          string-restrictions /
%%                          enum-specification /
%%                          leafref-specification /
%%                          identityref-specification /
%%                          instance-identifier-specification /
%%                          bits-specification /
%%                          union-specification
type_body_stmts -> numerical_restrictions            : '$1'.
type_body_stmts -> decimal64_specification           : '$1'.
type_body_stmts -> string_restrictions               : {string_restrictions,'$1'}.
type_body_stmts -> enum_specification                : '$1'.
type_body_stmts -> leafref_specification             : '$1'.
type_body_stmts -> identityref_specification         : '$1'.
type_body_stmts -> instance_identifier_specification : '$1'.
type_body_stmts -> bits_specification                : '$1'.
type_body_stmts -> union_specification               : '$1'.

%% leafref-specification =
%%                       ;; these stmts can appear in any order
%%                       path-stmt stmtsep
%%                       [require-instance-stmt stmtsep]
leafref_specification -> path_stmt : '$1'.
%% below creates 1 reduce/reduce since it's available anyway...
%leafref_specification -> require_instance_stmt.

%% path-stmt           = path-keyword sep path-arg-str stmtend
path_stmt -> path string ';' : {path, extract_token('$2')}.


%% instance-identifier-specification =
%%                       [require-instance-stmt stmtsep]
instance_identifier_specification -> require_instance_stmt : '$1'.

%% require-instance-stmt = require-instance-keyword sep
%%                          require-instance-arg-str stmtend
require_instance_stmt -> 'require-instance' true_or_false ';' : {'require-instace', extract_token('$2')}.

%% identityref-specification =
%%                       base-stmt stmtsep
identityref_specification -> base_stmt.

%% base-stmt           = base-keyword sep identifier-ref-arg-str
%%                       optsep stmtend
base_stmt -> base ident ';' : {base, extract_token('$2')}.


%% union-specification = 1*(type-stmt stmtsep)
% TODO does this mean several typ stmt?
union_specification -> type_stmt : '$1'.

%% bits-specification  = 1*(bit-stmt stmtsep)
%% todo what is this?
bits_specification -> bit_stmt : '$1'.

%% bit-stmt            = bit-keyword sep identifier-arg-str optsep
%%                        (";" /
%%                         "{" stmtsep
%%                             ;; these stmts can appear in any order
%%                             [position-stmt stmtsep]
%%                             [status-stmt stmtsep]
%%                             [description-stmt stmtsep]
%%                             [reference-stmt stmtsep]
%%                           "}"
%%                         "}")
bit_stmt -> bit ident bit_stmt_cont : {bit, extract_token('$2'), '$3'}.

bit_stmt_cont -> ';' : [].
bit_stmt_cont -> '{' bit_stmts '}' : '$2'.

bit_stmts -> '$empty' : [].
bit_stmts -> bit_stmtp bit_stmts : ['$1'|'$2'].

bit_stmtp -> position_stmt    : '$1'.
bit_stmtp -> status_stmt      : '$1'.
bit_stmtp -> description_stmt : '$1'.
bit_stmtp -> reference_stmt   : '$1'.

%% position-stmt       = position-keyword sep
%%                       position-value-arg-str stmtend
position_stmt -> position integer ';' : {position, extract_token('$2')}.

%% enum-specification  = 1*(enum-stmt stmtsep)
%% Todo not sure what this means
enum_specification -> enum_stmt : '$1'.

%% enum-stmt           = enum-keyword sep string optsep
%%                       (";" /
%%                        "{" stmtsep
%%                            ;; these stmts can appear in any order
%%                            [value-stmt stmtsep]
%%                            [status-stmt stmtsep]
%%                            [description-stmt stmtsep]
%%                            [reference-stmt stmtsep]
%%                         "}")
enum_stmt -> enum string enum_stmt_cont : {enum, extract_token('$2'), '$3'}.

enum_stmt_cont -> ';' : [].
enum_stmt_cont -> '{' enum_stmts '}' : '$2'.

enum_stmts -> '$empty' : [].
enum_stmts -> enum_stmtp enum_stmts : ['$1'|'$2'].

enum_stmtp -> value_stmt       : '$1'.
enum_stmtp -> status_stmt      : '$1'.
enum_stmtp -> description_stmt : '$1'.
enum_stmtp -> reference_stmt   : '$1'.

%% status-stmt         = status-keyword sep status-arg-str stmtend
status_stmt -> status status_arg ';' : {status, '$2'}.

%% status-arg          = current-keyword /
%%                       obsolete-keyword /
%%                       deprecated-keyword
status_arg -> current    : current.
status_arg -> obsolete   : obsolete.
status_arg -> deprecated : deprecated.

%% value-stmt          = value-keyword sep integer-value stmtend
value_stmt -> value integer ';' : {value, extract_token('$2')}.

%numerical-restrictions = range-stmt stmtsep
numerical_restrictions -> range_stmt : '$1'.

%% range-stmt          = range-keyword sep range-arg-str optsep
%%                       (";" /
%%                        "{" stmtsep
%%                            ;; these stmts can appear in any order
%%                            [error-message-stmt stmtsep]
%%                            [error-app-tag-stmt stmtsep]
%%                            [description-stmt stmtsep]
%%                            [reference-stmt stmtsep]
%%                         "}")
range_stmt -> range string range_stmt_cont : {range, extract_token('$2'), '$3'}.
range_stmt_cont -> ';' : [].
range_stmt_cont -> '{' range_stmts '}' : '$2'.

range_stmts -> '$empty' : [].
range_stmts -> range_stmtp range_stmts : ['$1'|'$2'].

range_stmtp -> error_message_stmt : '$1'.
range_stmtp -> error_app_tag_stmt : '$1'.
range_stmtp -> description_stmt   : '$1'.
range_stmtp -> reference_stmt     : '$1'.

%% error-message-stmt  = error-message-keyword sep string stmtend
error_message_stmt -> 'error-message' string ';' : {error_message, extract_token('$2')}.
%%error-app-tag-stmt  = error-app-tag-keyword sep string stmtend
error_app_tag_stmt -> 'error-app-tag' string ';' : {error_app_tag, extract_token('$2')}.

%% description-stmt    = description-keyword sep string optsep
%%                       stmtend
description_stmt -> description string ';' : {description, extract_token('$2')}.

%% reference-stmt      = reference-keyword sep string optsep stmtend
reference_stmt -> reference string ';' : {reference, extract_token('$2')}.

%%decimal64-specification = fraction-digits-stmt
decimal64_specification -> fraction_digits_stmt : '$1'.

%% fraction-digits-stmt = fraction-digits-keyword sep
%%                        fraction-digits-arg-str stmtend
fraction_digits_stmt -> 'fraction-digits' ';'. %% TODO

%% string-restrictions = ;; these stmts can appear in any order
%%                       [length-stmt stmtsep]
%%                       *(pattern-stmt stmtsep)
string_restrictions -> '$empty' : [].
string_restrictions -> string_restriction string_restrictions : ['$1'|'$2'].

string_restriction -> length_stmt : '$1'.
string_restriction -> pattern_stmt : '$1'.

%% length-stmt         = length-keyword sep length-arg-str optsep
%%                       (";" /
%%                        "{" stmtsep
%%                            ;; these stmts can appear in any order
%%                            [error-message-stmt stmtsep]
%%                            [error-app-tag-stmt stmtsep]
%%                            [description-stmt stmtsep]
%%                            [reference-stmt stmtsep]
%%                         "}")
length_stmt -> length string length_stmt_cont : {length, extract_token('$2'), '$3'}.
length_stmt_cont -> ';' : [].
length_stmt_cont -> '{' length_stmts '}': '$1'.

length_stmts -> '$empty' : [].
length_stmts -> length_stmtp length_stmts :  ['$1'|'$2'].

length_stmtp -> error_message_stmt : '$1'.
length_stmtp -> error_app_tag_stmt : '$1'.
length_stmtp -> description_stmt   : '$1'.
length_stmtp -> reference_stmt     : '$1'.

%% pattern-stmt        = pattern-keyword sep string optsep
%%                          (";" /
%%                           "{" stmtsep
%%                               ;; these stmts can appear in any order
%%                               [error-message-stmt stmtsep]
%%                               [error-app-tag-stmt stmtsep]
%%                               [description-stmt stmtsep]
%%                               [reference-stmt stmtsep]
%%                            "}")
%% pattern is some what of an odd child... enclosed in " or ' even though standard explicitly states
%% an unquoted string. It can also be "anded" using + together with other patterns...
pattern_stmt -> pattern string pattern_stmt_cont : {pattern, extract_token('$2'), '$3'}.
pattern_stmt -> pattern string_pattern pattern_stmt_cont : {pattern, extract_token('$2'), '$3'}.
pattern_stmt_cont -> ';' : [].
pattern_stmt_cont -> '{' pattern_stmts '}': '$1'.

pattern_stmts -> '$empty' : [].
pattern_stmts -> pattern_stmtp pattern_stmts :  ['$1'|'$2'].

pattern_stmtp -> error_message_stmt : '$1'.
pattern_stmtp -> error_app_tag_stmt : '$1'.
pattern_stmtp -> description_stmt   : '$1'.
pattern_stmtp -> reference_stmt     : '$1'.

%% units-stmt          = units-keyword sep string optsep stmtend
units_stmt -> units string ';' : {units, extract_token('$2')}.

%% default-stmt        = default-keyword sep string stmtend
default_stmt -> default string_or_int_or_float ';' : {default, '$2'}.

string_or_int_or_float -> string  : {string, extract_token('$1')}.
string_or_int_or_float -> integer : {integer, extract_token('$1')}.
string_or_int_or_float -> float   : {float, extract_token('$1')}.

%% status-stmt         = status-keyword sep status-arg-str stmtend
status_stmt -> status string ';' : {status, extract_token('$2')}.

%%"{" stmtsep
%%                             module-header-stmts
%%                             linkage-stmts
%%                             meta-stmts
%%                             revision-stmts
%%                             body-stmts
%%                         "}"



%% prefix STMT
%%
prefix_stmt -> prefix ident ';' : {prefix, extract_token('$2')}.
%% import-stmt         = import-keyword sep identifier-arg-str optsep
%%                          "{" stmtsep
%%                              prefix-stmt stmtsep
%%                              [revision-date-stmt stmtsep]
%%                          "}"
%% todo skip revision
import_stmt -> import ident '{' prefix_stmt '}': {import, extract_token('$2'), '$4'}.

%% include-stmt        = include-keyword sep identifier-arg-str optsep
%%                       (";" /
%%                        "{" stmtsep
%%                            [revision-date-stmt stmtsep]
%%                        "}")
include_stmt -> include ident include_stmt_cont : {include, extract_token('$2'), '$3'}.
include_stmt_cont -> ';' : empty.
include_stmt_cont -> '{' revision_date_stmts '}' : '$2'.

revision_date_stmts -> '$empty' : [].
revision_date_stmts ->  revision_date_stmt revision_date_stmts : ['$1'|'$2'].

revision_date_stmt -> 'revision-date' date ';' : extract_token('$2').


Erlang code.
extract_token({_Token, _Line, Value}) -> Value;
extract_token('$undefined') ->
    undefined.
