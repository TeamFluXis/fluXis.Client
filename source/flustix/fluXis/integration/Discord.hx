package flustix.fluXis.integration;

#if desktop
import discord_rpc.DiscordRpc;
import sys.thread.Thread;

class Discord {
	public function new() {
		DiscordRpc.start({
			clientID: "975141679583604767",
			onReady: onReady
		});

		while (true) {
			DiscordRpc.process();
			Sys.sleep(2);
		}
	}

	function onReady() {
		update({
			details: "yea"
		});
	}

	public static function update(options:DiscordPresenceOptions) {
		DiscordRpc.presence(options);
	}

	public static function init() {
		Thread.create(() -> {
			new Discord();
		});
	}
}
#end