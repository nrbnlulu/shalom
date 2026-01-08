// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, camel_case_types



















import 'package:shalom_core/shalom_core.dart' as shalom_core;










// ------------ Enum DEFINITIONS -------------

     
     /// Activity sort enums
     enum ActivitySort  {
          
                ID ,
          
                ID_DESC ,
          
                PINNED ;
          

          static ActivitySort fromString(String name) {
              switch (name) {
                  
                  case 'ID':
                    return ActivitySort.ID;                   
                  case 'ID_DESC':
                    return ActivitySort.ID_DESC;                   
                  case 'PINNED':
                    return ActivitySort.PINNED;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Activity type enum.
     enum ActivityType  {
          /// A anime list update activity
                ANIME_LIST ,
          /// A manga list update activity
                MANGA_LIST ,
          /// Anime & Manga list update, only used in query arguments
                MEDIA_LIST ,
          /// A text message activity sent to another user
                MESSAGE ,
          /// A text activity
                TEXT ;
          

          static ActivityType fromString(String name) {
              switch (name) {
                  
                  case 'ANIME_LIST':
                    return ActivityType.ANIME_LIST;                   
                  case 'MANGA_LIST':
                    return ActivityType.MANGA_LIST;                   
                  case 'MEDIA_LIST':
                    return ActivityType.MEDIA_LIST;                   
                  case 'MESSAGE':
                    return ActivityType.MESSAGE;                   
                  case 'TEXT':
                    return ActivityType.TEXT;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Airing schedule sort enums
     enum AiringSort  {
          
                EPISODE ,
          
                EPISODE_DESC ,
          
                ID ,
          
                ID_DESC ,
          
                MEDIA_ID ,
          
                MEDIA_ID_DESC ,
          
                TIME ,
          
                TIME_DESC ;
          

          static AiringSort fromString(String name) {
              switch (name) {
                  
                  case 'EPISODE':
                    return AiringSort.EPISODE;                   
                  case 'EPISODE_DESC':
                    return AiringSort.EPISODE_DESC;                   
                  case 'ID':
                    return AiringSort.ID;                   
                  case 'ID_DESC':
                    return AiringSort.ID_DESC;                   
                  case 'MEDIA_ID':
                    return AiringSort.MEDIA_ID;                   
                  case 'MEDIA_ID_DESC':
                    return AiringSort.MEDIA_ID_DESC;                   
                  case 'TIME':
                    return AiringSort.TIME;                   
                  case 'TIME_DESC':
                    return AiringSort.TIME_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// The role the character plays in the media
     enum CharacterRole  {
          /// A background character in the media
                BACKGROUND ,
          /// A primary character role in the media
                MAIN ,
          /// A supporting character role in the media
                SUPPORTING ;
          

          static CharacterRole fromString(String name) {
              switch (name) {
                  
                  case 'BACKGROUND':
                    return CharacterRole.BACKGROUND;                   
                  case 'MAIN':
                    return CharacterRole.MAIN;                   
                  case 'SUPPORTING':
                    return CharacterRole.SUPPORTING;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Character sort enums
     enum CharacterSort  {
          
                FAVOURITES ,
          
                FAVOURITES_DESC ,
          
                ID ,
          
                ID_DESC ,
          /// Order manually decided by moderators
                RELEVANCE ,
          
                ROLE ,
          
                ROLE_DESC ,
          
                SEARCH_MATCH ;
          

          static CharacterSort fromString(String name) {
              switch (name) {
                  
                  case 'FAVOURITES':
                    return CharacterSort.FAVOURITES;                   
                  case 'FAVOURITES_DESC':
                    return CharacterSort.FAVOURITES_DESC;                   
                  case 'ID':
                    return CharacterSort.ID;                   
                  case 'ID_DESC':
                    return CharacterSort.ID_DESC;                   
                  case 'RELEVANCE':
                    return CharacterSort.RELEVANCE;                   
                  case 'ROLE':
                    return CharacterSort.ROLE;                   
                  case 'ROLE_DESC':
                    return CharacterSort.ROLE_DESC;                   
                  case 'SEARCH_MATCH':
                    return CharacterSort.SEARCH_MATCH;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     
     enum ExternalLinkMediaType  {
          
                ANIME ,
          
                MANGA ,
          
                STAFF ;
          

          static ExternalLinkMediaType fromString(String name) {
              switch (name) {
                  
                  case 'ANIME':
                    return ExternalLinkMediaType.ANIME;                   
                  case 'MANGA':
                    return ExternalLinkMediaType.MANGA;                   
                  case 'STAFF':
                    return ExternalLinkMediaType.STAFF;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     
     enum ExternalLinkType  {
          
                INFO ,
          
                SOCIAL ,
          
                STREAMING ;
          

          static ExternalLinkType fromString(String name) {
              switch (name) {
                  
                  case 'INFO':
                    return ExternalLinkType.INFO;                   
                  case 'SOCIAL':
                    return ExternalLinkType.SOCIAL;                   
                  case 'STREAMING':
                    return ExternalLinkType.STREAMING;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Types that can be liked
     enum LikeableType  {
          
                ACTIVITY ,
          
                ACTIVITY_REPLY ,
          
                THREAD ,
          
                THREAD_COMMENT ;
          

          static LikeableType fromString(String name) {
              switch (name) {
                  
                  case 'ACTIVITY':
                    return LikeableType.ACTIVITY;                   
                  case 'ACTIVITY_REPLY':
                    return LikeableType.ACTIVITY_REPLY;                   
                  case 'THREAD':
                    return LikeableType.THREAD;                   
                  case 'THREAD_COMMENT':
                    return LikeableType.THREAD_COMMENT;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// The format the media was released in
     enum MediaFormat  {
          /// Professionally published manga with more than one chapter
                MANGA ,
          /// Anime movies with a theatrical release
                MOVIE ,
          /// Short anime released as a music video
                MUSIC ,
          /// Written books released as a series of light novels
                NOVEL ,
          /// (Original Net Animation) Anime that have been originally released online or are only available through streaming services.
                ONA ,
          /// Manga with just one chapter
                ONE_SHOT ,
          /// (Original Video Animation) Anime that have been released directly on
/// DVD/Blu-ray without originally going through a theatrical release or
/// television broadcast
                OVA ,
          /// Special episodes that have been included in DVD/Blu-ray releases, picture dramas, pilots, etc
                SPECIAL ,
          /// Anime broadcast on television
                TV ,
          /// Anime which are under 15 minutes in length and broadcast on television
                TV_SHORT ;
          

          static MediaFormat fromString(String name) {
              switch (name) {
                  
                  case 'MANGA':
                    return MediaFormat.MANGA;                   
                  case 'MOVIE':
                    return MediaFormat.MOVIE;                   
                  case 'MUSIC':
                    return MediaFormat.MUSIC;                   
                  case 'NOVEL':
                    return MediaFormat.NOVEL;                   
                  case 'ONA':
                    return MediaFormat.ONA;                   
                  case 'ONE_SHOT':
                    return MediaFormat.ONE_SHOT;                   
                  case 'OVA':
                    return MediaFormat.OVA;                   
                  case 'SPECIAL':
                    return MediaFormat.SPECIAL;                   
                  case 'TV':
                    return MediaFormat.TV;                   
                  case 'TV_SHORT':
                    return MediaFormat.TV_SHORT;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Media list sort enums
     enum MediaListSort  {
          
                ADDED_TIME ,
          
                ADDED_TIME_DESC ,
          
                FINISHED_ON ,
          
                FINISHED_ON_DESC ,
          
                MEDIA_ID ,
          
                MEDIA_ID_DESC ,
          
                MEDIA_POPULARITY ,
          
                MEDIA_POPULARITY_DESC ,
          
                MEDIA_TITLE_ENGLISH ,
          
                MEDIA_TITLE_ENGLISH_DESC ,
          
                MEDIA_TITLE_NATIVE ,
          
                MEDIA_TITLE_NATIVE_DESC ,
          
                MEDIA_TITLE_ROMAJI ,
          
                MEDIA_TITLE_ROMAJI_DESC ,
          
                PRIORITY ,
          
                PRIORITY_DESC ,
          
                PROGRESS ,
          
                PROGRESS_DESC ,
          
                PROGRESS_VOLUMES ,
          
                PROGRESS_VOLUMES_DESC ,
          
                REPEAT ,
          
                REPEAT_DESC ,
          
                SCORE ,
          
                SCORE_DESC ,
          
                STARTED_ON ,
          
                STARTED_ON_DESC ,
          
                STATUS ,
          
                STATUS_DESC ,
          
                UPDATED_TIME ,
          
                UPDATED_TIME_DESC ;
          

          static MediaListSort fromString(String name) {
              switch (name) {
                  
                  case 'ADDED_TIME':
                    return MediaListSort.ADDED_TIME;                   
                  case 'ADDED_TIME_DESC':
                    return MediaListSort.ADDED_TIME_DESC;                   
                  case 'FINISHED_ON':
                    return MediaListSort.FINISHED_ON;                   
                  case 'FINISHED_ON_DESC':
                    return MediaListSort.FINISHED_ON_DESC;                   
                  case 'MEDIA_ID':
                    return MediaListSort.MEDIA_ID;                   
                  case 'MEDIA_ID_DESC':
                    return MediaListSort.MEDIA_ID_DESC;                   
                  case 'MEDIA_POPULARITY':
                    return MediaListSort.MEDIA_POPULARITY;                   
                  case 'MEDIA_POPULARITY_DESC':
                    return MediaListSort.MEDIA_POPULARITY_DESC;                   
                  case 'MEDIA_TITLE_ENGLISH':
                    return MediaListSort.MEDIA_TITLE_ENGLISH;                   
                  case 'MEDIA_TITLE_ENGLISH_DESC':
                    return MediaListSort.MEDIA_TITLE_ENGLISH_DESC;                   
                  case 'MEDIA_TITLE_NATIVE':
                    return MediaListSort.MEDIA_TITLE_NATIVE;                   
                  case 'MEDIA_TITLE_NATIVE_DESC':
                    return MediaListSort.MEDIA_TITLE_NATIVE_DESC;                   
                  case 'MEDIA_TITLE_ROMAJI':
                    return MediaListSort.MEDIA_TITLE_ROMAJI;                   
                  case 'MEDIA_TITLE_ROMAJI_DESC':
                    return MediaListSort.MEDIA_TITLE_ROMAJI_DESC;                   
                  case 'PRIORITY':
                    return MediaListSort.PRIORITY;                   
                  case 'PRIORITY_DESC':
                    return MediaListSort.PRIORITY_DESC;                   
                  case 'PROGRESS':
                    return MediaListSort.PROGRESS;                   
                  case 'PROGRESS_DESC':
                    return MediaListSort.PROGRESS_DESC;                   
                  case 'PROGRESS_VOLUMES':
                    return MediaListSort.PROGRESS_VOLUMES;                   
                  case 'PROGRESS_VOLUMES_DESC':
                    return MediaListSort.PROGRESS_VOLUMES_DESC;                   
                  case 'REPEAT':
                    return MediaListSort.REPEAT;                   
                  case 'REPEAT_DESC':
                    return MediaListSort.REPEAT_DESC;                   
                  case 'SCORE':
                    return MediaListSort.SCORE;                   
                  case 'SCORE_DESC':
                    return MediaListSort.SCORE_DESC;                   
                  case 'STARTED_ON':
                    return MediaListSort.STARTED_ON;                   
                  case 'STARTED_ON_DESC':
                    return MediaListSort.STARTED_ON_DESC;                   
                  case 'STATUS':
                    return MediaListSort.STATUS;                   
                  case 'STATUS_DESC':
                    return MediaListSort.STATUS_DESC;                   
                  case 'UPDATED_TIME':
                    return MediaListSort.UPDATED_TIME;                   
                  case 'UPDATED_TIME_DESC':
                    return MediaListSort.UPDATED_TIME_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Media list watching/reading status enum.
     enum MediaListStatus  {
          /// Finished watching/reading
                COMPLETED ,
          /// Currently watching/reading
                CURRENT ,
          /// Stopped watching/reading before completing
                DROPPED ,
          /// Paused watching/reading
                PAUSED ,
          /// Planning to watch/read
                PLANNING ,
          /// Re-watching/reading
                REPEATING ;
          

          static MediaListStatus fromString(String name) {
              switch (name) {
                  
                  case 'COMPLETED':
                    return MediaListStatus.COMPLETED;                   
                  case 'CURRENT':
                    return MediaListStatus.CURRENT;                   
                  case 'DROPPED':
                    return MediaListStatus.DROPPED;                   
                  case 'PAUSED':
                    return MediaListStatus.PAUSED;                   
                  case 'PLANNING':
                    return MediaListStatus.PLANNING;                   
                  case 'REPEATING':
                    return MediaListStatus.REPEATING;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// The type of ranking
     enum MediaRankType  {
          /// Ranking is based on the media's popularity
                POPULAR ,
          /// Ranking is based on the media's ratings/score
                RATED ;
          

          static MediaRankType fromString(String name) {
              switch (name) {
                  
                  case 'POPULAR':
                    return MediaRankType.POPULAR;                   
                  case 'RATED':
                    return MediaRankType.RATED;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Type of relation media has to its parent.
     enum MediaRelation  {
          /// An adaption of this media into a different format
                ADAPTATION ,
          /// An alternative version of the same media
                ALTERNATIVE ,
          /// Shares at least 1 character
                CHARACTER ,
          /// Version 2 only.
                COMPILATION ,
          /// Version 2 only.
                CONTAINS ,
          /// Other
                OTHER ,
          /// The media a side story is from
                PARENT ,
          /// Released before the relation
                PREQUEL ,
          /// Released after the relation
                SEQUEL ,
          /// A side story of the parent media
                SIDE_STORY ,
          /// Version 2 only. The source material the media was adapted from
                SOURCE ,
          /// An alternative version of the media with a different primary focus
                SPIN_OFF ,
          /// A shortened and summarized version
                SUMMARY ;
          

          static MediaRelation fromString(String name) {
              switch (name) {
                  
                  case 'ADAPTATION':
                    return MediaRelation.ADAPTATION;                   
                  case 'ALTERNATIVE':
                    return MediaRelation.ALTERNATIVE;                   
                  case 'CHARACTER':
                    return MediaRelation.CHARACTER;                   
                  case 'COMPILATION':
                    return MediaRelation.COMPILATION;                   
                  case 'CONTAINS':
                    return MediaRelation.CONTAINS;                   
                  case 'OTHER':
                    return MediaRelation.OTHER;                   
                  case 'PARENT':
                    return MediaRelation.PARENT;                   
                  case 'PREQUEL':
                    return MediaRelation.PREQUEL;                   
                  case 'SEQUEL':
                    return MediaRelation.SEQUEL;                   
                  case 'SIDE_STORY':
                    return MediaRelation.SIDE_STORY;                   
                  case 'SOURCE':
                    return MediaRelation.SOURCE;                   
                  case 'SPIN_OFF':
                    return MediaRelation.SPIN_OFF;                   
                  case 'SUMMARY':
                    return MediaRelation.SUMMARY;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     
     enum MediaSeason  {
          /// Months September to November
                FALL ,
          /// Months March to May
                SPRING ,
          /// Months June to August
                SUMMER ,
          /// Months December to February
                WINTER ;
          

          static MediaSeason fromString(String name) {
              switch (name) {
                  
                  case 'FALL':
                    return MediaSeason.FALL;                   
                  case 'SPRING':
                    return MediaSeason.SPRING;                   
                  case 'SUMMER':
                    return MediaSeason.SUMMER;                   
                  case 'WINTER':
                    return MediaSeason.WINTER;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Media sort enums
     enum MediaSort  {
          
                CHAPTERS ,
          
                CHAPTERS_DESC ,
          
                DURATION ,
          
                DURATION_DESC ,
          
                END_DATE ,
          
                END_DATE_DESC ,
          
                EPISODES ,
          
                EPISODES_DESC ,
          
                FAVOURITES ,
          
                FAVOURITES_DESC ,
          
                FORMAT ,
          
                FORMAT_DESC ,
          
                ID ,
          
                ID_DESC ,
          
                POPULARITY ,
          
                POPULARITY_DESC ,
          
                SCORE ,
          
                SCORE_DESC ,
          
                SEARCH_MATCH ,
          
                START_DATE ,
          
                START_DATE_DESC ,
          
                STATUS ,
          
                STATUS_DESC ,
          
                TITLE_ENGLISH ,
          
                TITLE_ENGLISH_DESC ,
          
                TITLE_NATIVE ,
          
                TITLE_NATIVE_DESC ,
          
                TITLE_ROMAJI ,
          
                TITLE_ROMAJI_DESC ,
          
                TRENDING ,
          
                TRENDING_DESC ,
          
                TYPE ,
          
                TYPE_DESC ,
          
                UPDATED_AT ,
          
                UPDATED_AT_DESC ,
          
                VOLUMES ,
          
                VOLUMES_DESC ;
          

          static MediaSort fromString(String name) {
              switch (name) {
                  
                  case 'CHAPTERS':
                    return MediaSort.CHAPTERS;                   
                  case 'CHAPTERS_DESC':
                    return MediaSort.CHAPTERS_DESC;                   
                  case 'DURATION':
                    return MediaSort.DURATION;                   
                  case 'DURATION_DESC':
                    return MediaSort.DURATION_DESC;                   
                  case 'END_DATE':
                    return MediaSort.END_DATE;                   
                  case 'END_DATE_DESC':
                    return MediaSort.END_DATE_DESC;                   
                  case 'EPISODES':
                    return MediaSort.EPISODES;                   
                  case 'EPISODES_DESC':
                    return MediaSort.EPISODES_DESC;                   
                  case 'FAVOURITES':
                    return MediaSort.FAVOURITES;                   
                  case 'FAVOURITES_DESC':
                    return MediaSort.FAVOURITES_DESC;                   
                  case 'FORMAT':
                    return MediaSort.FORMAT;                   
                  case 'FORMAT_DESC':
                    return MediaSort.FORMAT_DESC;                   
                  case 'ID':
                    return MediaSort.ID;                   
                  case 'ID_DESC':
                    return MediaSort.ID_DESC;                   
                  case 'POPULARITY':
                    return MediaSort.POPULARITY;                   
                  case 'POPULARITY_DESC':
                    return MediaSort.POPULARITY_DESC;                   
                  case 'SCORE':
                    return MediaSort.SCORE;                   
                  case 'SCORE_DESC':
                    return MediaSort.SCORE_DESC;                   
                  case 'SEARCH_MATCH':
                    return MediaSort.SEARCH_MATCH;                   
                  case 'START_DATE':
                    return MediaSort.START_DATE;                   
                  case 'START_DATE_DESC':
                    return MediaSort.START_DATE_DESC;                   
                  case 'STATUS':
                    return MediaSort.STATUS;                   
                  case 'STATUS_DESC':
                    return MediaSort.STATUS_DESC;                   
                  case 'TITLE_ENGLISH':
                    return MediaSort.TITLE_ENGLISH;                   
                  case 'TITLE_ENGLISH_DESC':
                    return MediaSort.TITLE_ENGLISH_DESC;                   
                  case 'TITLE_NATIVE':
                    return MediaSort.TITLE_NATIVE;                   
                  case 'TITLE_NATIVE_DESC':
                    return MediaSort.TITLE_NATIVE_DESC;                   
                  case 'TITLE_ROMAJI':
                    return MediaSort.TITLE_ROMAJI;                   
                  case 'TITLE_ROMAJI_DESC':
                    return MediaSort.TITLE_ROMAJI_DESC;                   
                  case 'TRENDING':
                    return MediaSort.TRENDING;                   
                  case 'TRENDING_DESC':
                    return MediaSort.TRENDING_DESC;                   
                  case 'TYPE':
                    return MediaSort.TYPE;                   
                  case 'TYPE_DESC':
                    return MediaSort.TYPE_DESC;                   
                  case 'UPDATED_AT':
                    return MediaSort.UPDATED_AT;                   
                  case 'UPDATED_AT_DESC':
                    return MediaSort.UPDATED_AT_DESC;                   
                  case 'VOLUMES':
                    return MediaSort.VOLUMES;                   
                  case 'VOLUMES_DESC':
                    return MediaSort.VOLUMES_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Source type the media was adapted from
     enum MediaSource  {
          /// Version 2+ only. Japanese Anime
                ANIME ,
          /// Version 3 only. Comics excluding manga
                COMIC ,
          /// Version 2+ only. Self-published works
                DOUJINSHI ,
          /// Version 3 only. Games excluding video games
                GAME ,
          /// Written work published in volumes
                LIGHT_NOVEL ,
          /// Version 3 only. Live action media such as movies or TV show
                LIVE_ACTION ,
          /// Asian comic book
                MANGA ,
          /// Version 3 only. Multimedia project
                MULTIMEDIA_PROJECT ,
          /// Version 2+ only. Written works not published in volumes
                NOVEL ,
          /// An original production not based of another work
                ORIGINAL ,
          /// Other
                OTHER ,
          /// Version 3 only. Picture book
                PICTURE_BOOK ,
          /// Video game
                VIDEO_GAME ,
          /// Video game driven primary by text and narrative
                VISUAL_NOVEL ,
          /// Version 3 only. Written works published online
                WEB_NOVEL ;
          

          static MediaSource fromString(String name) {
              switch (name) {
                  
                  case 'ANIME':
                    return MediaSource.ANIME;                   
                  case 'COMIC':
                    return MediaSource.COMIC;                   
                  case 'DOUJINSHI':
                    return MediaSource.DOUJINSHI;                   
                  case 'GAME':
                    return MediaSource.GAME;                   
                  case 'LIGHT_NOVEL':
                    return MediaSource.LIGHT_NOVEL;                   
                  case 'LIVE_ACTION':
                    return MediaSource.LIVE_ACTION;                   
                  case 'MANGA':
                    return MediaSource.MANGA;                   
                  case 'MULTIMEDIA_PROJECT':
                    return MediaSource.MULTIMEDIA_PROJECT;                   
                  case 'NOVEL':
                    return MediaSource.NOVEL;                   
                  case 'ORIGINAL':
                    return MediaSource.ORIGINAL;                   
                  case 'OTHER':
                    return MediaSource.OTHER;                   
                  case 'PICTURE_BOOK':
                    return MediaSource.PICTURE_BOOK;                   
                  case 'VIDEO_GAME':
                    return MediaSource.VIDEO_GAME;                   
                  case 'VISUAL_NOVEL':
                    return MediaSource.VISUAL_NOVEL;                   
                  case 'WEB_NOVEL':
                    return MediaSource.WEB_NOVEL;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// The current releasing status of the media
     enum MediaStatus  {
          /// Ended before the work could be finished
                CANCELLED ,
          /// Has completed and is no longer being released
                FINISHED ,
          /// Version 2 only. Is currently paused from releasing and will resume at a later date
                HIATUS ,
          /// To be released at a later date
                NOT_YET_RELEASED ,
          /// Currently releasing
                RELEASING ;
          

          static MediaStatus fromString(String name) {
              switch (name) {
                  
                  case 'CANCELLED':
                    return MediaStatus.CANCELLED;                   
                  case 'FINISHED':
                    return MediaStatus.FINISHED;                   
                  case 'HIATUS':
                    return MediaStatus.HIATUS;                   
                  case 'NOT_YET_RELEASED':
                    return MediaStatus.NOT_YET_RELEASED;                   
                  case 'RELEASING':
                    return MediaStatus.RELEASING;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Media trend sort enums
     enum MediaTrendSort  {
          
                DATE ,
          
                DATE_DESC ,
          
                EPISODE ,
          
                EPISODE_DESC ,
          
                ID ,
          
                ID_DESC ,
          
                MEDIA_ID ,
          
                MEDIA_ID_DESC ,
          
                POPULARITY ,
          
                POPULARITY_DESC ,
          
                SCORE ,
          
                SCORE_DESC ,
          
                TRENDING ,
          
                TRENDING_DESC ;
          

          static MediaTrendSort fromString(String name) {
              switch (name) {
                  
                  case 'DATE':
                    return MediaTrendSort.DATE;                   
                  case 'DATE_DESC':
                    return MediaTrendSort.DATE_DESC;                   
                  case 'EPISODE':
                    return MediaTrendSort.EPISODE;                   
                  case 'EPISODE_DESC':
                    return MediaTrendSort.EPISODE_DESC;                   
                  case 'ID':
                    return MediaTrendSort.ID;                   
                  case 'ID_DESC':
                    return MediaTrendSort.ID_DESC;                   
                  case 'MEDIA_ID':
                    return MediaTrendSort.MEDIA_ID;                   
                  case 'MEDIA_ID_DESC':
                    return MediaTrendSort.MEDIA_ID_DESC;                   
                  case 'POPULARITY':
                    return MediaTrendSort.POPULARITY;                   
                  case 'POPULARITY_DESC':
                    return MediaTrendSort.POPULARITY_DESC;                   
                  case 'SCORE':
                    return MediaTrendSort.SCORE;                   
                  case 'SCORE_DESC':
                    return MediaTrendSort.SCORE_DESC;                   
                  case 'TRENDING':
                    return MediaTrendSort.TRENDING;                   
                  case 'TRENDING_DESC':
                    return MediaTrendSort.TRENDING_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Media type enum, anime or manga.
     enum MediaType  {
          /// Japanese Anime
                ANIME ,
          /// Asian comic
                MANGA ;
          

          static MediaType fromString(String name) {
              switch (name) {
                  
                  case 'ANIME':
                    return MediaType.ANIME;                   
                  case 'MANGA':
                    return MediaType.MANGA;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     
     enum ModActionType  {
          
                ANON ,
          
                BAN ,
          
                DELETE ,
          
                EDIT ,
          
                EXPIRE ,
          
                NOTE ,
          
                REPORT ,
          
                RESET ;
          

          static ModActionType fromString(String name) {
              switch (name) {
                  
                  case 'ANON':
                    return ModActionType.ANON;                   
                  case 'BAN':
                    return ModActionType.BAN;                   
                  case 'DELETE':
                    return ModActionType.DELETE;                   
                  case 'EDIT':
                    return ModActionType.EDIT;                   
                  case 'EXPIRE':
                    return ModActionType.EXPIRE;                   
                  case 'NOTE':
                    return ModActionType.NOTE;                   
                  case 'REPORT':
                    return ModActionType.REPORT;                   
                  case 'RESET':
                    return ModActionType.RESET;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Mod role enums
     enum ModRole  {
          /// An AniList administrator
                ADMIN ,
          /// An anime data moderator
                ANIME_DATA ,
          /// A character data moderator
                CHARACTER_DATA ,
          /// A community moderator
                COMMUNITY ,
          /// An AniList developer
                DEVELOPER ,
          /// A discord community moderator
                DISCORD_COMMUNITY ,
          /// A lead anime data moderator
                LEAD_ANIME_DATA ,
          /// A lead community moderator
                LEAD_COMMUNITY ,
          /// A head developer of AniList
                LEAD_DEVELOPER ,
          /// A lead manga data moderator
                LEAD_MANGA_DATA ,
          /// A lead social media moderator
                LEAD_SOCIAL_MEDIA ,
          /// A manga data moderator
                MANGA_DATA ,
          /// A retired moderator
                RETIRED ,
          /// A social media moderator
                SOCIAL_MEDIA ,
          /// A staff data moderator
                STAFF_DATA ;
          

          static ModRole fromString(String name) {
              switch (name) {
                  
                  case 'ADMIN':
                    return ModRole.ADMIN;                   
                  case 'ANIME_DATA':
                    return ModRole.ANIME_DATA;                   
                  case 'CHARACTER_DATA':
                    return ModRole.CHARACTER_DATA;                   
                  case 'COMMUNITY':
                    return ModRole.COMMUNITY;                   
                  case 'DEVELOPER':
                    return ModRole.DEVELOPER;                   
                  case 'DISCORD_COMMUNITY':
                    return ModRole.DISCORD_COMMUNITY;                   
                  case 'LEAD_ANIME_DATA':
                    return ModRole.LEAD_ANIME_DATA;                   
                  case 'LEAD_COMMUNITY':
                    return ModRole.LEAD_COMMUNITY;                   
                  case 'LEAD_DEVELOPER':
                    return ModRole.LEAD_DEVELOPER;                   
                  case 'LEAD_MANGA_DATA':
                    return ModRole.LEAD_MANGA_DATA;                   
                  case 'LEAD_SOCIAL_MEDIA':
                    return ModRole.LEAD_SOCIAL_MEDIA;                   
                  case 'MANGA_DATA':
                    return ModRole.MANGA_DATA;                   
                  case 'RETIRED':
                    return ModRole.RETIRED;                   
                  case 'SOCIAL_MEDIA':
                    return ModRole.SOCIAL_MEDIA;                   
                  case 'STAFF_DATA':
                    return ModRole.STAFF_DATA;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Notification type enum
     enum NotificationType  {
          /// A user has liked your activity
                ACTIVITY_LIKE ,
          /// A user has mentioned you in their activity
                ACTIVITY_MENTION ,
          /// A user has sent you message
                ACTIVITY_MESSAGE ,
          /// A user has replied to your activity
                ACTIVITY_REPLY ,
          /// A user has liked your activity reply
                ACTIVITY_REPLY_LIKE ,
          /// A user has replied to activity you have also replied to
                ACTIVITY_REPLY_SUBSCRIBED ,
          /// An anime you are currently watching has aired
                AIRING ,
          /// A user has followed you
                FOLLOWING ,
          /// An anime or manga has had a data change that affects how a user may track it in their lists
                MEDIA_DATA_CHANGE ,
          /// An anime or manga on the user's list has been deleted from the site
                MEDIA_DELETION ,
          /// Anime or manga entries on the user's list have been merged into a single entry
                MEDIA_MERGE ,
          /// A new anime or manga has been added to the site where its related media is on the user's list
                RELATED_MEDIA_ADDITION ,
          /// A user has liked your forum comment
                THREAD_COMMENT_LIKE ,
          /// A user has mentioned you in a forum comment
                THREAD_COMMENT_MENTION ,
          /// A user has replied to your forum comment
                THREAD_COMMENT_REPLY ,
          /// A user has liked your forum thread
                THREAD_LIKE ,
          /// A user has commented in one of your subscribed forum threads
                THREAD_SUBSCRIBED ;
          

          static NotificationType fromString(String name) {
              switch (name) {
                  
                  case 'ACTIVITY_LIKE':
                    return NotificationType.ACTIVITY_LIKE;                   
                  case 'ACTIVITY_MENTION':
                    return NotificationType.ACTIVITY_MENTION;                   
                  case 'ACTIVITY_MESSAGE':
                    return NotificationType.ACTIVITY_MESSAGE;                   
                  case 'ACTIVITY_REPLY':
                    return NotificationType.ACTIVITY_REPLY;                   
                  case 'ACTIVITY_REPLY_LIKE':
                    return NotificationType.ACTIVITY_REPLY_LIKE;                   
                  case 'ACTIVITY_REPLY_SUBSCRIBED':
                    return NotificationType.ACTIVITY_REPLY_SUBSCRIBED;                   
                  case 'AIRING':
                    return NotificationType.AIRING;                   
                  case 'FOLLOWING':
                    return NotificationType.FOLLOWING;                   
                  case 'MEDIA_DATA_CHANGE':
                    return NotificationType.MEDIA_DATA_CHANGE;                   
                  case 'MEDIA_DELETION':
                    return NotificationType.MEDIA_DELETION;                   
                  case 'MEDIA_MERGE':
                    return NotificationType.MEDIA_MERGE;                   
                  case 'RELATED_MEDIA_ADDITION':
                    return NotificationType.RELATED_MEDIA_ADDITION;                   
                  case 'THREAD_COMMENT_LIKE':
                    return NotificationType.THREAD_COMMENT_LIKE;                   
                  case 'THREAD_COMMENT_MENTION':
                    return NotificationType.THREAD_COMMENT_MENTION;                   
                  case 'THREAD_COMMENT_REPLY':
                    return NotificationType.THREAD_COMMENT_REPLY;                   
                  case 'THREAD_LIKE':
                    return NotificationType.THREAD_LIKE;                   
                  case 'THREAD_SUBSCRIBED':
                    return NotificationType.THREAD_SUBSCRIBED;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Recommendation rating enums
     enum RecommendationRating  {
          
                NO_RATING ,
          
                RATE_DOWN ,
          
                RATE_UP ;
          

          static RecommendationRating fromString(String name) {
              switch (name) {
                  
                  case 'NO_RATING':
                    return RecommendationRating.NO_RATING;                   
                  case 'RATE_DOWN':
                    return RecommendationRating.RATE_DOWN;                   
                  case 'RATE_UP':
                    return RecommendationRating.RATE_UP;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Recommendation sort enums
     enum RecommendationSort  {
          
                ID ,
          
                ID_DESC ,
          
                RATING ,
          
                RATING_DESC ;
          

          static RecommendationSort fromString(String name) {
              switch (name) {
                  
                  case 'ID':
                    return RecommendationSort.ID;                   
                  case 'ID_DESC':
                    return RecommendationSort.ID_DESC;                   
                  case 'RATING':
                    return RecommendationSort.RATING;                   
                  case 'RATING_DESC':
                    return RecommendationSort.RATING_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Review rating enums
     enum ReviewRating  {
          
                DOWN_VOTE ,
          
                NO_VOTE ,
          
                UP_VOTE ;
          

          static ReviewRating fromString(String name) {
              switch (name) {
                  
                  case 'DOWN_VOTE':
                    return ReviewRating.DOWN_VOTE;                   
                  case 'NO_VOTE':
                    return ReviewRating.NO_VOTE;                   
                  case 'UP_VOTE':
                    return ReviewRating.UP_VOTE;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Review sort enums
     enum ReviewSort  {
          
                CREATED_AT ,
          
                CREATED_AT_DESC ,
          
                ID ,
          
                ID_DESC ,
          
                RATING ,
          
                RATING_DESC ,
          
                SCORE ,
          
                SCORE_DESC ,
          
                UPDATED_AT ,
          
                UPDATED_AT_DESC ;
          

          static ReviewSort fromString(String name) {
              switch (name) {
                  
                  case 'CREATED_AT':
                    return ReviewSort.CREATED_AT;                   
                  case 'CREATED_AT_DESC':
                    return ReviewSort.CREATED_AT_DESC;                   
                  case 'ID':
                    return ReviewSort.ID;                   
                  case 'ID_DESC':
                    return ReviewSort.ID_DESC;                   
                  case 'RATING':
                    return ReviewSort.RATING;                   
                  case 'RATING_DESC':
                    return ReviewSort.RATING_DESC;                   
                  case 'SCORE':
                    return ReviewSort.SCORE;                   
                  case 'SCORE_DESC':
                    return ReviewSort.SCORE_DESC;                   
                  case 'UPDATED_AT':
                    return ReviewSort.UPDATED_AT;                   
                  case 'UPDATED_AT_DESC':
                    return ReviewSort.UPDATED_AT_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Revision history actions
     enum RevisionHistoryAction  {
          
                CREATE ,
          
                EDIT ;
          

          static RevisionHistoryAction fromString(String name) {
              switch (name) {
                  
                  case 'CREATE':
                    return RevisionHistoryAction.CREATE;                   
                  case 'EDIT':
                    return RevisionHistoryAction.EDIT;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Media list scoring type
     enum ScoreFormat  {
          /// An integer from 0-10
                POINT_10 ,
          /// An integer from 0-100
                POINT_100 ,
          /// A float from 0-10 with 1 decimal place
                POINT_10_DECIMAL ,
          /// An integer from 0-3. Should be represented in Smileys. 0 => No Score, 1 => :(, 2 => :|, 3 => :)
                POINT_3 ,
          /// An integer from 0-5. Should be represented in Stars
                POINT_5 ;
          

          static ScoreFormat fromString(String name) {
              switch (name) {
                  
                  case 'POINT_10':
                    return ScoreFormat.POINT_10;                   
                  case 'POINT_100':
                    return ScoreFormat.POINT_100;                   
                  case 'POINT_10_DECIMAL':
                    return ScoreFormat.POINT_10_DECIMAL;                   
                  case 'POINT_3':
                    return ScoreFormat.POINT_3;                   
                  case 'POINT_5':
                    return ScoreFormat.POINT_5;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Site trend sort enums
     enum SiteTrendSort  {
          
                CHANGE ,
          
                CHANGE_DESC ,
          
                COUNT ,
          
                COUNT_DESC ,
          
                DATE ,
          
                DATE_DESC ;
          

          static SiteTrendSort fromString(String name) {
              switch (name) {
                  
                  case 'CHANGE':
                    return SiteTrendSort.CHANGE;                   
                  case 'CHANGE_DESC':
                    return SiteTrendSort.CHANGE_DESC;                   
                  case 'COUNT':
                    return SiteTrendSort.COUNT;                   
                  case 'COUNT_DESC':
                    return SiteTrendSort.COUNT_DESC;                   
                  case 'DATE':
                    return SiteTrendSort.DATE;                   
                  case 'DATE_DESC':
                    return SiteTrendSort.DATE_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// The primary language of the voice actor
     enum StaffLanguage  {
          /// English
                ENGLISH ,
          /// French
                FRENCH ,
          /// German
                GERMAN ,
          /// Hebrew
                HEBREW ,
          /// Hungarian
                HUNGARIAN ,
          /// Italian
                ITALIAN ,
          /// Japanese
                JAPANESE ,
          /// Korean
                KOREAN ,
          /// Portuguese
                PORTUGUESE ,
          /// Spanish
                SPANISH ;
          

          static StaffLanguage fromString(String name) {
              switch (name) {
                  
                  case 'ENGLISH':
                    return StaffLanguage.ENGLISH;                   
                  case 'FRENCH':
                    return StaffLanguage.FRENCH;                   
                  case 'GERMAN':
                    return StaffLanguage.GERMAN;                   
                  case 'HEBREW':
                    return StaffLanguage.HEBREW;                   
                  case 'HUNGARIAN':
                    return StaffLanguage.HUNGARIAN;                   
                  case 'ITALIAN':
                    return StaffLanguage.ITALIAN;                   
                  case 'JAPANESE':
                    return StaffLanguage.JAPANESE;                   
                  case 'KOREAN':
                    return StaffLanguage.KOREAN;                   
                  case 'PORTUGUESE':
                    return StaffLanguage.PORTUGUESE;                   
                  case 'SPANISH':
                    return StaffLanguage.SPANISH;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Staff sort enums
     enum StaffSort  {
          
                FAVOURITES ,
          
                FAVOURITES_DESC ,
          
                ID ,
          
                ID_DESC ,
          
                LANGUAGE ,
          
                LANGUAGE_DESC ,
          /// Order manually decided by moderators
                RELEVANCE ,
          
                ROLE ,
          
                ROLE_DESC ,
          
                SEARCH_MATCH ;
          

          static StaffSort fromString(String name) {
              switch (name) {
                  
                  case 'FAVOURITES':
                    return StaffSort.FAVOURITES;                   
                  case 'FAVOURITES_DESC':
                    return StaffSort.FAVOURITES_DESC;                   
                  case 'ID':
                    return StaffSort.ID;                   
                  case 'ID_DESC':
                    return StaffSort.ID_DESC;                   
                  case 'LANGUAGE':
                    return StaffSort.LANGUAGE;                   
                  case 'LANGUAGE_DESC':
                    return StaffSort.LANGUAGE_DESC;                   
                  case 'RELEVANCE':
                    return StaffSort.RELEVANCE;                   
                  case 'ROLE':
                    return StaffSort.ROLE;                   
                  case 'ROLE_DESC':
                    return StaffSort.ROLE_DESC;                   
                  case 'SEARCH_MATCH':
                    return StaffSort.SEARCH_MATCH;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Studio sort enums
     enum StudioSort  {
          
                FAVOURITES ,
          
                FAVOURITES_DESC ,
          
                ID ,
          
                ID_DESC ,
          
                NAME ,
          
                NAME_DESC ,
          
                SEARCH_MATCH ;
          

          static StudioSort fromString(String name) {
              switch (name) {
                  
                  case 'FAVOURITES':
                    return StudioSort.FAVOURITES;                   
                  case 'FAVOURITES_DESC':
                    return StudioSort.FAVOURITES_DESC;                   
                  case 'ID':
                    return StudioSort.ID;                   
                  case 'ID_DESC':
                    return StudioSort.ID_DESC;                   
                  case 'NAME':
                    return StudioSort.NAME;                   
                  case 'NAME_DESC':
                    return StudioSort.NAME_DESC;                   
                  case 'SEARCH_MATCH':
                    return StudioSort.SEARCH_MATCH;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Submission sort enums
     enum SubmissionSort  {
          
                ID ,
          
                ID_DESC ;
          

          static SubmissionSort fromString(String name) {
              switch (name) {
                  
                  case 'ID':
                    return SubmissionSort.ID;                   
                  case 'ID_DESC':
                    return SubmissionSort.ID_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Submission status
     enum SubmissionStatus  {
          
                ACCEPTED ,
          
                PARTIALLY_ACCEPTED ,
          
                PENDING ,
          
                REJECTED ;
          

          static SubmissionStatus fromString(String name) {
              switch (name) {
                  
                  case 'ACCEPTED':
                    return SubmissionStatus.ACCEPTED;                   
                  case 'PARTIALLY_ACCEPTED':
                    return SubmissionStatus.PARTIALLY_ACCEPTED;                   
                  case 'PENDING':
                    return SubmissionStatus.PENDING;                   
                  case 'REJECTED':
                    return SubmissionStatus.REJECTED;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Thread comments sort enums
     enum ThreadCommentSort  {
          
                ID ,
          
                ID_DESC ;
          

          static ThreadCommentSort fromString(String name) {
              switch (name) {
                  
                  case 'ID':
                    return ThreadCommentSort.ID;                   
                  case 'ID_DESC':
                    return ThreadCommentSort.ID_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// Thread sort enums
     enum ThreadSort  {
          
                CREATED_AT ,
          
                CREATED_AT_DESC ,
          
                ID ,
          
                ID_DESC ,
          
                IS_STICKY ,
          
                REPLIED_AT ,
          
                REPLIED_AT_DESC ,
          
                REPLY_COUNT ,
          
                REPLY_COUNT_DESC ,
          
                SEARCH_MATCH ,
          
                TITLE ,
          
                TITLE_DESC ,
          
                UPDATED_AT ,
          
                UPDATED_AT_DESC ,
          
                VIEW_COUNT ,
          
                VIEW_COUNT_DESC ;
          

          static ThreadSort fromString(String name) {
              switch (name) {
                  
                  case 'CREATED_AT':
                    return ThreadSort.CREATED_AT;                   
                  case 'CREATED_AT_DESC':
                    return ThreadSort.CREATED_AT_DESC;                   
                  case 'ID':
                    return ThreadSort.ID;                   
                  case 'ID_DESC':
                    return ThreadSort.ID_DESC;                   
                  case 'IS_STICKY':
                    return ThreadSort.IS_STICKY;                   
                  case 'REPLIED_AT':
                    return ThreadSort.REPLIED_AT;                   
                  case 'REPLIED_AT_DESC':
                    return ThreadSort.REPLIED_AT_DESC;                   
                  case 'REPLY_COUNT':
                    return ThreadSort.REPLY_COUNT;                   
                  case 'REPLY_COUNT_DESC':
                    return ThreadSort.REPLY_COUNT_DESC;                   
                  case 'SEARCH_MATCH':
                    return ThreadSort.SEARCH_MATCH;                   
                  case 'TITLE':
                    return ThreadSort.TITLE;                   
                  case 'TITLE_DESC':
                    return ThreadSort.TITLE_DESC;                   
                  case 'UPDATED_AT':
                    return ThreadSort.UPDATED_AT;                   
                  case 'UPDATED_AT_DESC':
                    return ThreadSort.UPDATED_AT_DESC;                   
                  case 'VIEW_COUNT':
                    return ThreadSort.VIEW_COUNT;                   
                  case 'VIEW_COUNT_DESC':
                    return ThreadSort.VIEW_COUNT_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// User sort enums
     enum UserSort  {
          
                CHAPTERS_READ ,
          
                CHAPTERS_READ_DESC ,
          
                ID ,
          
                ID_DESC ,
          
                SEARCH_MATCH ,
          
                USERNAME ,
          
                USERNAME_DESC ,
          
                WATCHED_TIME ,
          
                WATCHED_TIME_DESC ;
          

          static UserSort fromString(String name) {
              switch (name) {
                  
                  case 'CHAPTERS_READ':
                    return UserSort.CHAPTERS_READ;                   
                  case 'CHAPTERS_READ_DESC':
                    return UserSort.CHAPTERS_READ_DESC;                   
                  case 'ID':
                    return UserSort.ID;                   
                  case 'ID_DESC':
                    return UserSort.ID_DESC;                   
                  case 'SEARCH_MATCH':
                    return UserSort.SEARCH_MATCH;                   
                  case 'USERNAME':
                    return UserSort.USERNAME;                   
                  case 'USERNAME_DESC':
                    return UserSort.USERNAME_DESC;                   
                  case 'WATCHED_TIME':
                    return UserSort.WATCHED_TIME;                   
                  case 'WATCHED_TIME_DESC':
                    return UserSort.WATCHED_TIME_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// The language the user wants to see staff and character names in
     enum UserStaffNameLanguage  {
          /// The staff or character's name in their native language
                NATIVE ,
          /// The romanization of the staff or character's native name
                ROMAJI ,
          /// The romanization of the staff or character's native name, with western name ordering
                ROMAJI_WESTERN ;
          

          static UserStaffNameLanguage fromString(String name) {
              switch (name) {
                  
                  case 'NATIVE':
                    return UserStaffNameLanguage.NATIVE;                   
                  case 'ROMAJI':
                    return UserStaffNameLanguage.ROMAJI;                   
                  case 'ROMAJI_WESTERN':
                    return UserStaffNameLanguage.ROMAJI_WESTERN;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// User statistics sort enum
     enum UserStatisticsSort  {
          
                COUNT ,
          
                COUNT_DESC ,
          
                ID ,
          
                ID_DESC ,
          
                MEAN_SCORE ,
          
                MEAN_SCORE_DESC ,
          
                PROGRESS ,
          
                PROGRESS_DESC ;
          

          static UserStatisticsSort fromString(String name) {
              switch (name) {
                  
                  case 'COUNT':
                    return UserStatisticsSort.COUNT;                   
                  case 'COUNT_DESC':
                    return UserStatisticsSort.COUNT_DESC;                   
                  case 'ID':
                    return UserStatisticsSort.ID;                   
                  case 'ID_DESC':
                    return UserStatisticsSort.ID_DESC;                   
                  case 'MEAN_SCORE':
                    return UserStatisticsSort.MEAN_SCORE;                   
                  case 'MEAN_SCORE_DESC':
                    return UserStatisticsSort.MEAN_SCORE_DESC;                   
                  case 'PROGRESS':
                    return UserStatisticsSort.PROGRESS;                   
                  case 'PROGRESS_DESC':
                    return UserStatisticsSort.PROGRESS_DESC;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

     
     /// The language the user wants to see media titles in
     enum UserTitleLanguage  {
          /// The official english title
                ENGLISH ,
          /// The official english title, stylised by media creator
                ENGLISH_STYLISED ,
          /// Official title in it's native language
                NATIVE ,
          /// Official title in it's native language, stylised by media creator
                NATIVE_STYLISED ,
          /// The romanization of the native language title
                ROMAJI ,
          /// The romanization of the native language title, stylised by media creator
                ROMAJI_STYLISED ;
          

          static UserTitleLanguage fromString(String name) {
              switch (name) {
                  
                  case 'ENGLISH':
                    return UserTitleLanguage.ENGLISH;                   
                  case 'ENGLISH_STYLISED':
                    return UserTitleLanguage.ENGLISH_STYLISED;                   
                  case 'NATIVE':
                    return UserTitleLanguage.NATIVE;                   
                  case 'NATIVE_STYLISED':
                    return UserTitleLanguage.NATIVE_STYLISED;                   
                  case 'ROMAJI':
                    return UserTitleLanguage.ROMAJI;                   
                  case 'ROMAJI_STYLISED':
                    return UserTitleLanguage.ROMAJI_STYLISED;                   
                  default:
                      throw ArgumentError.value(name, 'name', 'No enum member with this name');
              }
          }

      }

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------






class AiringScheduleInput {
    final shalom_core.Maybe<int?> airingAt;
    final shalom_core.Maybe<int?> episode;
    final shalom_core.Maybe<int?> timeUntilAiring;
    AiringScheduleInput(
        {
        
    
        
            
                
                this.airingAt = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.episode = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.timeUntilAiring = const shalom_core.None()
            
        
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
if (airingAt.isSome()) {
            final value = this.airingAt.some();
            data["airingAt"] = 
    
        value
    
;
        }
    if (episode.isSome()) {
            final value = this.episode.some();
            data["episode"] = 
    
        value
    
;
        }
    if (timeUntilAiring.isSome()) {
            final value = this.timeUntilAiring.some();
            data["timeUntilAiring"] = 
    
        value
    
;
        }
    
        return data;
    }

    @override
    String toString() {
        return toJson().toString();
    }

  

AiringScheduleInput updateWith(
    {
        shalom_core.Maybe<shalom_core.Maybe<int?>> airingAt = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<int?>> episode = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<int?>> timeUntilAiring = const shalom_core.None()
            
        }
) {
    
        
            final airingAt$next = switch (airingAt) {
                shalom_core.Some() => airingAt.value,
                shalom_core.None() => this.airingAt
            };
        
        
            final episode$next = switch (episode) {
                shalom_core.Some() => episode.value,
                shalom_core.None() => this.episode
            };
        
        
            final timeUntilAiring$next = switch (timeUntilAiring) {
                shalom_core.Some() => timeUntilAiring.value,
                shalom_core.None() => this.timeUntilAiring
            };
        
    return AiringScheduleInput(
        
            airingAt:airingAt$next.isSome() ? shalom_core.Some(airingAt$next.some()) : const shalom_core.None()
                ,
        
            episode:episode$next.isSome() ? shalom_core.Some(episode$next.some()) : const shalom_core.None()
                ,
        
            timeUntilAiring:timeUntilAiring$next.isSome() ? shalom_core.Some(timeUntilAiring$next.some()) : const shalom_core.None()
                
        );
}

}








class AniChartHighlightInput {
    final shalom_core.Maybe<String?> highlight;
    final shalom_core.Maybe<int?> mediaId;
    AniChartHighlightInput(
        {
        
    
        
            
                
                this.highlight = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.mediaId = const shalom_core.None()
            
        
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
if (highlight.isSome()) {
            final value = this.highlight.some();
            data["highlight"] = 
    
        value
    
;
        }
    if (mediaId.isSome()) {
            final value = this.mediaId.some();
            data["mediaId"] = 
    
        value
    
;
        }
    
        return data;
    }

    @override
    String toString() {
        return toJson().toString();
    }

  

AniChartHighlightInput updateWith(
    {
        shalom_core.Maybe<shalom_core.Maybe<String?>> highlight = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<int?>> mediaId = const shalom_core.None()
            
        }
) {
    
        
            final highlight$next = switch (highlight) {
                shalom_core.Some() => highlight.value,
                shalom_core.None() => this.highlight
            };
        
        
            final mediaId$next = switch (mediaId) {
                shalom_core.Some() => mediaId.value,
                shalom_core.None() => this.mediaId
            };
        
    return AniChartHighlightInput(
        
            highlight:highlight$next.isSome() ? shalom_core.Some(highlight$next.some()) : const shalom_core.None()
                ,
        
            mediaId:mediaId$next.isSome() ? shalom_core.Some(mediaId$next.some()) : const shalom_core.None()
                
        );
}

}







/// The names of the character
class CharacterNameInput {
    final shalom_core.Maybe<List<String?>?> alternative;
    final shalom_core.Maybe<List<String?>?> alternativeSpoiler;
    final shalom_core.Maybe<String?> first;
    final shalom_core.Maybe<String?> last;
    final shalom_core.Maybe<String?> middle;
    final shalom_core.Maybe<String?> native;
    CharacterNameInput(
        {
        
    
        
            
                
                this.alternative = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.alternativeSpoiler = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.first = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.last = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.middle = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.native = const shalom_core.None()
            
        
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
if (alternative.isSome()) {
            final value = this.alternative.some();
            data["alternative"] = 
    
        
        
            value?.map((e) => 
    
        e
    
).toList()
        
    
;
        }
    if (alternativeSpoiler.isSome()) {
            final value = this.alternativeSpoiler.some();
            data["alternativeSpoiler"] = 
    
        
        
            value?.map((e) => 
    
        e
    
).toList()
        
    
;
        }
    if (first.isSome()) {
            final value = this.first.some();
            data["first"] = 
    
        value
    
;
        }
    if (last.isSome()) {
            final value = this.last.some();
            data["last"] = 
    
        value
    
;
        }
    if (middle.isSome()) {
            final value = this.middle.some();
            data["middle"] = 
    
        value
    
;
        }
    if (native.isSome()) {
            final value = this.native.some();
            data["native"] = 
    
        value
    
;
        }
    
        return data;
    }

    @override
    String toString() {
        return toJson().toString();
    }

  

CharacterNameInput updateWith(
    {
        shalom_core.Maybe<shalom_core.Maybe<List<String?>?>> alternative = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<List<String?>?>> alternativeSpoiler = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<String?>> first = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<String?>> last = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<String?>> middle = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<String?>> native = const shalom_core.None()
            
        }
) {
    
        
            final alternative$next = switch (alternative) {
                shalom_core.Some() => alternative.value,
                shalom_core.None() => this.alternative
            };
        
        
            final alternativeSpoiler$next = switch (alternativeSpoiler) {
                shalom_core.Some() => alternativeSpoiler.value,
                shalom_core.None() => this.alternativeSpoiler
            };
        
        
            final first$next = switch (first) {
                shalom_core.Some() => first.value,
                shalom_core.None() => this.first
            };
        
        
            final last$next = switch (last) {
                shalom_core.Some() => last.value,
                shalom_core.None() => this.last
            };
        
        
            final middle$next = switch (middle) {
                shalom_core.Some() => middle.value,
                shalom_core.None() => this.middle
            };
        
        
            final native$next = switch (native) {
                shalom_core.Some() => native.value,
                shalom_core.None() => this.native
            };
        
    return CharacterNameInput(
        
            alternative:alternative$next.isSome() ? shalom_core.Some(alternative$next.some()) : const shalom_core.None()
                ,
        
            alternativeSpoiler:alternativeSpoiler$next.isSome() ? shalom_core.Some(alternativeSpoiler$next.some()) : const shalom_core.None()
                ,
        
            first:first$next.isSome() ? shalom_core.Some(first$next.some()) : const shalom_core.None()
                ,
        
            last:last$next.isSome() ? shalom_core.Some(last$next.some()) : const shalom_core.None()
                ,
        
            middle:middle$next.isSome() ? shalom_core.Some(middle$next.some()) : const shalom_core.None()
                ,
        
            native:native$next.isSome() ? shalom_core.Some(native$next.some()) : const shalom_core.None()
                
        );
}

}







/// Date object that allows for incomplete date values (fuzzy)
class FuzzyDateInput {
    final shalom_core.Maybe<int?> day;
    final shalom_core.Maybe<int?> month;
    final shalom_core.Maybe<int?> year;
    FuzzyDateInput(
        {
        
    
        
            
                
                this.day = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.month = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.year = const shalom_core.None()
            
        
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
if (day.isSome()) {
            final value = this.day.some();
            data["day"] = 
    
        value
    
;
        }
    if (month.isSome()) {
            final value = this.month.some();
            data["month"] = 
    
        value
    
;
        }
    if (year.isSome()) {
            final value = this.year.some();
            data["year"] = 
    
        value
    
;
        }
    
        return data;
    }

    @override
    String toString() {
        return toJson().toString();
    }

  

FuzzyDateInput updateWith(
    {
        shalom_core.Maybe<shalom_core.Maybe<int?>> day = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<int?>> month = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<int?>> year = const shalom_core.None()
            
        }
) {
    
        
            final day$next = switch (day) {
                shalom_core.Some() => day.value,
                shalom_core.None() => this.day
            };
        
        
            final month$next = switch (month) {
                shalom_core.Some() => month.value,
                shalom_core.None() => this.month
            };
        
        
            final year$next = switch (year) {
                shalom_core.Some() => year.value,
                shalom_core.None() => this.year
            };
        
    return FuzzyDateInput(
        
            day:day$next.isSome() ? shalom_core.Some(day$next.some()) : const shalom_core.None()
                ,
        
            month:month$next.isSome() ? shalom_core.Some(month$next.some()) : const shalom_core.None()
                ,
        
            year:year$next.isSome() ? shalom_core.Some(year$next.some()) : const shalom_core.None()
                
        );
}

}








class ListActivityOptionInput {
    final shalom_core.Maybe<bool?> disabled;
    final shalom_core.Maybe<MediaListStatus?> type;
    ListActivityOptionInput(
        {
        
    
        
            
                
                this.disabled = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.type = const shalom_core.None()
            
        
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
if (disabled.isSome()) {
            final value = this.disabled.some();
            data["disabled"] = 
    
        value
    
;
        }
    if (type.isSome()) {
            final value = this.type.some();
            data["type"] = 
    
        
            value?.name
        
    
;
        }
    
        return data;
    }

    @override
    String toString() {
        return toJson().toString();
    }

  

ListActivityOptionInput updateWith(
    {
        shalom_core.Maybe<shalom_core.Maybe<bool?>> disabled = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<MediaListStatus?>> type = const shalom_core.None()
            
        }
) {
    
        
            final disabled$next = switch (disabled) {
                shalom_core.Some() => disabled.value,
                shalom_core.None() => this.disabled
            };
        
        
            final type$next = switch (type) {
                shalom_core.Some() => type.value,
                shalom_core.None() => this.type
            };
        
    return ListActivityOptionInput(
        
            disabled:disabled$next.isSome() ? shalom_core.Some(disabled$next.some()) : const shalom_core.None()
                ,
        
            type:type$next.isSome() ? shalom_core.Some(type$next.some()) : const shalom_core.None()
                
        );
}

}







/// An external link to another site related to the media
class MediaExternalLinkInput {
    final int id;
    final String site;
    final String url;
    MediaExternalLinkInput(
        {
        
    
        required this.id
            
    
,
            
    
        required this.site
            
    
,
            
    
        required this.url
            
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
data["id"] = 
    
        this.id
    
;
    data["site"] = 
    
        this.site
    
;
    data["url"] = 
    
        this.url
    
;
    
        return data;
    }

    @override
    String toString() {
        return toJson().toString();
    }

  

MediaExternalLinkInput updateWith(
    {
        int? id
            ,
        String? site
            ,
        String? url
            
        }
) {
    
        
            final id$next = id ?? this.id;
        
        
            final site$next = site ?? this.site;
        
        
            final url$next = url ?? this.url;
        
    return MediaExternalLinkInput(
        
            id:id$next,
        
            site:site$next,
        
            url:url$next
        );
}

}







/// A user's list options for anime or manga lists
class MediaListOptionsInput {
    final shalom_core.Maybe<List<String?>?> advancedScoring;
    final shalom_core.Maybe<bool?> advancedScoringEnabled;
    final shalom_core.Maybe<List<String?>?> customLists;
    final shalom_core.Maybe<List<String?>?> sectionOrder;
    final shalom_core.Maybe<bool?> splitCompletedSectionByFormat;
    final shalom_core.Maybe<String?> theme;
    MediaListOptionsInput(
        {
        
    
        
            
                
                this.advancedScoring = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.advancedScoringEnabled = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.customLists = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.sectionOrder = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.splitCompletedSectionByFormat = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.theme = const shalom_core.None()
            
        
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
if (advancedScoring.isSome()) {
            final value = this.advancedScoring.some();
            data["advancedScoring"] = 
    
        
        
            value?.map((e) => 
    
        e
    
).toList()
        
    
;
        }
    if (advancedScoringEnabled.isSome()) {
            final value = this.advancedScoringEnabled.some();
            data["advancedScoringEnabled"] = 
    
        value
    
;
        }
    if (customLists.isSome()) {
            final value = this.customLists.some();
            data["customLists"] = 
    
        
        
            value?.map((e) => 
    
        e
    
).toList()
        
    
;
        }
    if (sectionOrder.isSome()) {
            final value = this.sectionOrder.some();
            data["sectionOrder"] = 
    
        
        
            value?.map((e) => 
    
        e
    
).toList()
        
    
;
        }
    if (splitCompletedSectionByFormat.isSome()) {
            final value = this.splitCompletedSectionByFormat.some();
            data["splitCompletedSectionByFormat"] = 
    
        value
    
;
        }
    if (theme.isSome()) {
            final value = this.theme.some();
            data["theme"] = 
    
        value
    
;
        }
    
        return data;
    }

    @override
    String toString() {
        return toJson().toString();
    }

  

MediaListOptionsInput updateWith(
    {
        shalom_core.Maybe<shalom_core.Maybe<List<String?>?>> advancedScoring = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<bool?>> advancedScoringEnabled = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<List<String?>?>> customLists = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<List<String?>?>> sectionOrder = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<bool?>> splitCompletedSectionByFormat = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<String?>> theme = const shalom_core.None()
            
        }
) {
    
        
            final advancedScoring$next = switch (advancedScoring) {
                shalom_core.Some() => advancedScoring.value,
                shalom_core.None() => this.advancedScoring
            };
        
        
            final advancedScoringEnabled$next = switch (advancedScoringEnabled) {
                shalom_core.Some() => advancedScoringEnabled.value,
                shalom_core.None() => this.advancedScoringEnabled
            };
        
        
            final customLists$next = switch (customLists) {
                shalom_core.Some() => customLists.value,
                shalom_core.None() => this.customLists
            };
        
        
            final sectionOrder$next = switch (sectionOrder) {
                shalom_core.Some() => sectionOrder.value,
                shalom_core.None() => this.sectionOrder
            };
        
        
            final splitCompletedSectionByFormat$next = switch (splitCompletedSectionByFormat) {
                shalom_core.Some() => splitCompletedSectionByFormat.value,
                shalom_core.None() => this.splitCompletedSectionByFormat
            };
        
        
            final theme$next = switch (theme) {
                shalom_core.Some() => theme.value,
                shalom_core.None() => this.theme
            };
        
    return MediaListOptionsInput(
        
            advancedScoring:advancedScoring$next.isSome() ? shalom_core.Some(advancedScoring$next.some()) : const shalom_core.None()
                ,
        
            advancedScoringEnabled:advancedScoringEnabled$next.isSome() ? shalom_core.Some(advancedScoringEnabled$next.some()) : const shalom_core.None()
                ,
        
            customLists:customLists$next.isSome() ? shalom_core.Some(customLists$next.some()) : const shalom_core.None()
                ,
        
            sectionOrder:sectionOrder$next.isSome() ? shalom_core.Some(sectionOrder$next.some()) : const shalom_core.None()
                ,
        
            splitCompletedSectionByFormat:splitCompletedSectionByFormat$next.isSome() ? shalom_core.Some(splitCompletedSectionByFormat$next.some()) : const shalom_core.None()
                ,
        
            theme:theme$next.isSome() ? shalom_core.Some(theme$next.some()) : const shalom_core.None()
                
        );
}

}







/// The official titles of the media in various languages
class MediaTitleInput {
    final shalom_core.Maybe<String?> english;
    final shalom_core.Maybe<String?> native;
    final shalom_core.Maybe<String?> romaji;
    MediaTitleInput(
        {
        
    
        
            
                
                this.english = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.native = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.romaji = const shalom_core.None()
            
        
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
if (english.isSome()) {
            final value = this.english.some();
            data["english"] = 
    
        value
    
;
        }
    if (native.isSome()) {
            final value = this.native.some();
            data["native"] = 
    
        value
    
;
        }
    if (romaji.isSome()) {
            final value = this.romaji.some();
            data["romaji"] = 
    
        value
    
;
        }
    
        return data;
    }

    @override
    String toString() {
        return toJson().toString();
    }

  

MediaTitleInput updateWith(
    {
        shalom_core.Maybe<shalom_core.Maybe<String?>> english = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<String?>> native = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<String?>> romaji = const shalom_core.None()
            
        }
) {
    
        
            final english$next = switch (english) {
                shalom_core.Some() => english.value,
                shalom_core.None() => this.english
            };
        
        
            final native$next = switch (native) {
                shalom_core.Some() => native.value,
                shalom_core.None() => this.native
            };
        
        
            final romaji$next = switch (romaji) {
                shalom_core.Some() => romaji.value,
                shalom_core.None() => this.romaji
            };
        
    return MediaTitleInput(
        
            english:english$next.isSome() ? shalom_core.Some(english$next.some()) : const shalom_core.None()
                ,
        
            native:native$next.isSome() ? shalom_core.Some(native$next.some()) : const shalom_core.None()
                ,
        
            romaji:romaji$next.isSome() ? shalom_core.Some(romaji$next.some()) : const shalom_core.None()
                
        );
}

}







/// Notification option input
class NotificationOptionInput {
    final shalom_core.Maybe<bool?> enabled;
    final shalom_core.Maybe<NotificationType?> type;
    NotificationOptionInput(
        {
        
    
        
            
                
                this.enabled = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.type = const shalom_core.None()
            
        
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
if (enabled.isSome()) {
            final value = this.enabled.some();
            data["enabled"] = 
    
        value
    
;
        }
    if (type.isSome()) {
            final value = this.type.some();
            data["type"] = 
    
        
            value?.name
        
    
;
        }
    
        return data;
    }

    @override
    String toString() {
        return toJson().toString();
    }

  

NotificationOptionInput updateWith(
    {
        shalom_core.Maybe<shalom_core.Maybe<bool?>> enabled = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<NotificationType?>> type = const shalom_core.None()
            
        }
) {
    
        
            final enabled$next = switch (enabled) {
                shalom_core.Some() => enabled.value,
                shalom_core.None() => this.enabled
            };
        
        
            final type$next = switch (type) {
                shalom_core.Some() => type.value,
                shalom_core.None() => this.type
            };
        
    return NotificationOptionInput(
        
            enabled:enabled$next.isSome() ? shalom_core.Some(enabled$next.some()) : const shalom_core.None()
                ,
        
            type:type$next.isSome() ? shalom_core.Some(type$next.some()) : const shalom_core.None()
                
        );
}

}







/// The names of the staff member
class StaffNameInput {
    final shalom_core.Maybe<List<String?>?> alternative;
    final shalom_core.Maybe<String?> first;
    final shalom_core.Maybe<String?> last;
    final shalom_core.Maybe<String?> middle;
    final shalom_core.Maybe<String?> native;
    StaffNameInput(
        {
        
    
        
            
                
                this.alternative = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.first = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.last = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.middle = const shalom_core.None()
            
        
    
,
            
    
        
            
                
                this.native = const shalom_core.None()
            
        
    
,
            }
    )


;

    shalom_core.JsonObject toJson() {
        shalom_core.JsonObject data = {};
        
if (alternative.isSome()) {
            final value = this.alternative.some();
            data["alternative"] = 
    
        
        
            value?.map((e) => 
    
        e
    
).toList()
        
    
;
        }
    if (first.isSome()) {
            final value = this.first.some();
            data["first"] = 
    
        value
    
;
        }
    if (last.isSome()) {
            final value = this.last.some();
            data["last"] = 
    
        value
    
;
        }
    if (middle.isSome()) {
            final value = this.middle.some();
            data["middle"] = 
    
        value
    
;
        }
    if (native.isSome()) {
            final value = this.native.some();
            data["native"] = 
    
        value
    
;
        }
    
        return data;
    }

    @override
    String toString() {
        return toJson().toString();
    }

  

StaffNameInput updateWith(
    {
        shalom_core.Maybe<shalom_core.Maybe<List<String?>?>> alternative = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<String?>> first = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<String?>> last = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<String?>> middle = const shalom_core.None()
            ,
        shalom_core.Maybe<shalom_core.Maybe<String?>> native = const shalom_core.None()
            
        }
) {
    
        
            final alternative$next = switch (alternative) {
                shalom_core.Some() => alternative.value,
                shalom_core.None() => this.alternative
            };
        
        
            final first$next = switch (first) {
                shalom_core.Some() => first.value,
                shalom_core.None() => this.first
            };
        
        
            final last$next = switch (last) {
                shalom_core.Some() => last.value,
                shalom_core.None() => this.last
            };
        
        
            final middle$next = switch (middle) {
                shalom_core.Some() => middle.value,
                shalom_core.None() => this.middle
            };
        
        
            final native$next = switch (native) {
                shalom_core.Some() => native.value,
                shalom_core.None() => this.native
            };
        
    return StaffNameInput(
        
            alternative:alternative$next.isSome() ? shalom_core.Some(alternative$next.some()) : const shalom_core.None()
                ,
        
            first:first$next.isSome() ? shalom_core.Some(first$next.some()) : const shalom_core.None()
                ,
        
            last:last$next.isSome() ? shalom_core.Some(last$next.some()) : const shalom_core.None()
                ,
        
            middle:middle$next.isSome() ? shalom_core.Some(middle$next.some()) : const shalom_core.None()
                ,
        
            native:native$next.isSome() ? shalom_core.Some(native$next.some()) : const shalom_core.None()
                
        );
}

}



// ------------ END Input DEFINITIONS -------------