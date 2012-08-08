# -*- coding: utf-8 -*-

PLUGIN_NAME = u'Remove Perfect Albums'
PLUGIN_AUTHOR = u'ichneumon, hrglgrmpf'
PLUGIN_DESCRIPTION = u'''Remove all perfectly matched albums from the selection.'''
PLUGIN_VERSION = '0.2'
PLUGIN_API_VERSIONS = ['0.15']

# heavily based on code from 'The Sorting Plugin' by Aaron Lambers
# see http://forums.musicbrainz.org/viewtopic.php?id=2489

# Updated to Picard 0.15 and simplified by hrglgrmpf

from picard.album import Album
from picard.ui.itemviews import BaseAction, register_album_action

class RemovePerfectAlbums(BaseAction):
    NAME = 'Remove perfect albums'

    def callback(self, objs):
        for album in objs:
            if isinstance(album, Album) and album.is_complete() and album.get_num_unmatched_files() == 0\
               and album.get_num_matched_tracks() == len(list(album.iterfiles()))\
               and album.get_num_unsaved_files() == 0 and album.loaded == True:
                self.tagger.remove_album(album)

register_album_action(RemovePerfectAlbums())
