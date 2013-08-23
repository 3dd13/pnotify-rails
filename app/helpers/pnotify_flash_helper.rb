module PnotifyFlashHelper
  ALERT_TYPES = [:error, :info, :success, :warning]

  def pnotify_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type == :notice
      type = :error   if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        jquery_script = <<-Javascript
        <script type="text/javascript">
        $(function(){
          $.pnotify({
            title: '#{type.capitalize}',
            text: '#{msg}',
            type: '#{type}'
          });
        });
        </script>
        Javascript

        flash_messages << jquery_script if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
end
