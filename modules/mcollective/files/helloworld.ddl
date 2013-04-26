metadata :name        => "Echo Agent",
          :description => "A simple echo agent",
          :author      => "Scott",
          :license     => "GPLv2",
          :version     => "1.1",
          :url         => "http://projects.puppetlabs.com/projects/mcollective-plugins/wiki",
          :timeout     => 60

requires :mcollective => "2.0.0"

action "echo", :description => "prints a message" do
     display :always
 
     input :msg,
           :prompt      => "Message",
           :description => "the message to echo",
           :type        => :string,
           :validation  => '^[a-zA-Z\-_\d]+$',
           :optional    => false,
           :default     => "default echo message",
           :maxlength   => 30
 
     output :msg,
            :description => "the message being echoed",
            :display_as  => "message",
            :default     => ""
end
