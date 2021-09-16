this.raiders_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.raiders_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_94.png[/img]{After you and your party killed half of them, the villagers finally submitted. A white flag was raised, and they offered parlay which you were happy to grant. In a single line they walked out to the town square where they had been holding a festival. Jewels and treasures filled their arms and they dumped the goods where you stood, boot atop the smashed skull of their mayor. Your vanguard of %raider1%, %raider2%, %raider3% and %raider4% kept careful watch of the ceremony like buzzards watching a slow death.\n\n The last in the line was a monk. He had no gold or silver on him, but instead spoke to you, his words immediately drawing the weapons of your fellow raiders. You allowed him to speak, and he spoke at length about the old gods and how the treasures of the heavens superseded all of that which terra could offer. You told him his death was written by that wagging chin of his. The monk pursed his lips.%SPEECH_ON%Alright, then if you want gold, depart these silly games. This raiding and pillaging, it is all worthless compared to the treasures of the south. The nobles won\'t have you in their armies, but they are forever in need of mercenaries and rarely have the time or luxury of choosing where these hired fighters come from. You\'d make all the crowns you\'d ever want. Come south, raiders, and be sublimated into sellswords.%SPEECH_OFF%%raider3% demands the monk\'s head, but you stay the execution. Instead, you take the crafty monk at his word. You\'ve long heard of southern riches and the travels of adventurous swords for hire. You decide to venture south - so long as the monk comes with. %raider3% protests, but you won\'t have it. If this pale little shit of a monk is your lucky charm to a new life, then it would be an affront to the old gods to leave him be. The raider storms off, but %raider1%, %raider2% and %raider4% have no qualms about following you. The rest of the war party returns north, a split in the loot being made. What remains of the village is left behind to recover, rebuild, and make new goods for stronger tribes to come and take for themselves.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll strike out south.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The Northern Raiders";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"raider1",
			brothers[0].getName()
		]);
		_vars.push([
			"raider2",
			brothers[1].getName()
		]);
		_vars.push([
			"raider3",
			this.Const.Strings.BarbarianNames[this.Math.rand(0, this.Const.Strings.BarbarianNames.len() - 1)]
		]);
		_vars.push([
			"raider4",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});

