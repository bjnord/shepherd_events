module EventsHelper
  def ics_time(datetime, zone = nil)
    if zone.blank?
      datetime.utc.strftime(":%Y%m%dT%H%M%SZ")
    else
      datetime.strftime(";TZID=#{zone}:%Y%m%dT%H%M%S")
    end
  end

  def ics_uuid(url)
    UUIDTools::UUID.sha1_create(UUIDTools::UUID_DNS_NAMESPACE, url)
  end

  def ics_fold(line)
    return "" if !line
    # FIXME '\\\1' doesn't work for some reason; do two-step shuffle for now
    line.gsub!(/([,;])/, '§\1')
    line.gsub!(/§/, '\\')
    lines = line.chars.each_slice(75).map(&:join)
    lines.join("\r\n ").html_safe
  end

  def ics_name
    APP_CONFIG['ics_name'] || 'Event Calendar'
  end

  def ics_prodid_domain
    APP_CONFIG['ics_prodid_domain'] || 'Example.org'
  end

  def ics_time_zone
    APP_CONFIG['ics_time_zone'] || 'America/Chicago'
  end
end
