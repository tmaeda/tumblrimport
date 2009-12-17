#
#  tumblrimport.rb
#  tumblrimport
#
#  Created by tmaeda on 09/08/30.
#  Copyright (c) 2009 tmaeda. All rights reserved.
#
$KCODE = 'u'
require 'osx/cocoa'
include OSX

require 'tumblr4r'

class TumblrImport < OSX::NSObject
  include OSX
  def init
    super_init
    return self
  end

  # @param path [String]
  # @param result [Hash]
  def extractFrom_to(path, result)
    NSLog("path=#{path}")
    post = YAML.load_file(path)

    case post.type
    when Tumblr4r::POST_TYPE::REGULAR
      result["kMDItemKind"] = "TumblrImport regular"
      result["kMDItemTitle"] = post.regular_title || ""
      result["kMDItemTextContext"] = post.regular_body || ""
    when Tumblr4r::POST_TYPE::PHOTO
      result["kMDItemKind"] = "TumblrImport photo"
      result["kMDItemTitle"] = post.photo_url || ""
      result["kMDItemTextContext"] = post.photo_caption || ""
    when Tumblr4r::POST_TYPE::QUOTE
      result["kMDItemKind"] = "TumblrImport quote"
      result["kMDItemTitle"] = post.quote_source || ""
      result["kMDItemTextContext"] = post.quote_text || ""
    when Tumblr4r::POST_TYPE::LINK
      result["kMDItemKind"] = "TumblrImport link"
      result["kMDItemTitle"] = post.link_text || ""
      result["kMDItemTextContext"] = post.link_description || ""
    when Tumblr4r::POST_TYPE::CHAT
      result["kMDItemKind"] = "TumblrImport conversation"
      result["kMDItemTitle"] = post.conversation_title || ""
      result["kMDItemTextContext"] = post.conversation_text || ""
    when Tumblr4r::POST_TYPE::AUDIO
      result["kMDItemKind"] = "TumblrImport audio"
#      result["kMDItemTitle"] = post.
      result["kMDItemTextContext"] = post.audio_caption || ""
    when Tumblr4r::POST_TYPE::VIDEO
      result["kMDItemKind"] = "TumblrImport video"
      result["kMDItemTitle"] = post.title || ""
      result["kMDItemTextContext"] = post.video_caption || ""
    else
      raise "Unknown post_type #{post.type}"
    end

    result["kMDItemWhereFroms"] = post.url || ""
    result["kMDItemComment"] = post.url || ""
    require 'time'
    result["kMDItemContentModificationDate"] = Time.parse(post.date)#.xmlschema.gsub("T", " ")
    #result["kMDItemContentModificationDate"][-6, 1] = " +"
    result["kMDItemKeywords"] = post.tags.join(", ")

    NSLog("result=%@", result.map{|k,v| "#{k} => #{v}"}.join("\n"))
#kMDItemComment, kMDItemContentCreationDate, kMDItemContentModificationDate, kMDItemContentType
#kMDItemCreator, kMDItemDescription(abstract, TOC...), kMDItemFinderComment, kMDItemHeadline,
#kMDItemIdentifier?, kMDItemKeywords, kMDItemKind, kMDItemTextContent

    result # 何も返さなくていいんだけど、一応。
  end
end
