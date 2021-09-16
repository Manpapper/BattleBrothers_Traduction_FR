this.traveler_north_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.traveler_north";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{You come across a man beside a hole in the ice. He\'s got a fishing pole next to him and, despite the environment, welcomes you warmly.%SPEECH_ON%Care to have a chat, traveler? You don\'t seem to be from these parts.%SPEECH_OFF% | A man wearing bear fur is cutting a hole in the ice. He looks at you just as the rim of his cuts drops and he punches it into the water.%SPEECH_ON%Come traveler, take ease beside me for a time. I\'m harmless.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Join us at the campfire for tonight.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "No, keep your distance.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]{You ask the man if the North has seen any devastating wars. He shrugs.%SPEECH_ON%Aye, we\'ve our differences. This spat and that. But a century ago a collective of warriors was formed to defeat a horde of undead. Ohh ya, see it in yer eyes that ye didn\'t know that one. It is likely that if they were defeated the walking corpses would have flooded south and killed you all. You\'re welcome. Bet they don\'t teach that in your fancy southern scripts.%SPEECH_OFF% | The man snorts and nods at the fishing pole.%SPEECH_ON%They say there\'s large fish down under there. Harmless ones, but big enough to spur the imagination. I can\'t say I\'ve seen them in the flesh, but there was a time when a large shadow passed beneath my feet, passed right there through the waters, and it passed and passed, felt like forever. And then it was gone.%SPEECH_OFF%You ask how he thinks it a harmless beast. He shrugs.%SPEECH_ON%Cause it didn\'t do nothing but go from there to there and onward still.%SPEECH_OFF% | The man tests a fishing pole then crouches on his haunches. He nods across the ice.%SPEECH_ON%Ol\' white bears will cross these stretches. Gotta keep your mind out for \'em. A bit of fire will fend them off, that or you dump your fish and make a run for it. I\'d known a man who got eaten by a white bear. They said it ate him from legs up, giving no shits about his screaming and hollering. I\'d sooner slit my own throat than let one of them beasts get a hold of me.%SPEECH_OFF% | A friendly enough fellow, the man rests beside his fishing poles and speaks to the nature of his own people.%SPEECH_ON%I\'d been close enough south to know you think us savages. That\'s quite alright, but there\'s more to it than that, or less I suppose. We got less. Far less. And make do with it anyhow.%SPEECH_OFF%You remark that northerners frequent the south only to rape and pillage what it has. The man shrugs.%SPEECH_ON%And you send war parties north to treat us to a sense of southern justice. Seems fair enough. Nobody\'s doing nothing that don\'t have a bit of retribution hanging there clear as day to see. We\'re all on level.%SPEECH_OFF% | As you set beside the man he catches a fish and yanks it onto the ice. He grasps it with a fur-gloved hand and smashes its head to stop its flopping. He talks as he guts and salts it.%SPEECH_ON%Some of the northerners figured out a way to tame them giants, the unholds I think you call them.  Don\'t ask me how. Anytime I\'d heard of a giant going anywhere all it did was kill anyone in its path and eat all the livestock.%SPEECH_OFF% | The man snorts and tests his fishing rods and sighs when there\'s no pull.%SPEECH_ON%I went south a few years back. Stayed there a few years just as well. That\'s how I know your tongue so well. When I was down that way, I tasted what you call vegetables. Disgusting things, truly, and the south wonders how we grow so big and strong up there in these wastes? I\'ll tell ya, we can\'t grow no fucking vegetables. Only thing we eat has to die and nothing with a heartbeat is willing to die easy.%SPEECH_OFF% | The friendly northern fisherman tells you stories of how the tribes come and go.%SPEECH_ON%I\'ll say this much, we\'re only run by the strong, but a strong man is only as good as his health and constitution. When he gets old, he loses both. When he gets old, he therefore loses. And so the new strong man comes to power, and with it a shattering of the tribe\'s history and successes. I do in part envy the southerner\'s sense of greater purpose, and the southerner\'s ability to hide his power, to stock it at arm\'s length so that others must do more than just swing a sword to get it from him. I tell you this in truth, and only here, as far away from my countrymen as I can be. You\'ll never hear me say any of this around no ordinary campfire, understand?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We need another drink.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.8)
		{
			return;
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

