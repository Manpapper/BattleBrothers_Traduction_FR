this.holywar_intro_north_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_intro_north";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{%SPEECH_START%Alright, alright, sort yerself, sort yerself.%SPEECH_OFF%You come to a peasant holding court with, unsurprisingly, more peasants.%SPEECH_ON%Now I just got told that these Gilded farks in the south think their \'maker\' has something in store for the old gods.%SPEECH_OFF%A voice from the crowd asks what that could be. The speaker shrugs.%SPEECH_ON%Dunno. Now, I think we can all agree that the old gods settled their wars many years ago, and there\'s no need for violence. But the Gilder, he ain\'t no old god. That there is a heresy.%SPEECH_OFF%The crowd cheers. You\'re beginning to wonder if this man is a cleric in commoner\'s clothing. He continues.%SPEECH_ON%Gather up yer weapons, yer armor, yer gold, and most importantly, yer faith, we\'re going to put some shadow on that \'Gilder\'! The old gods will it!%SPEECH_OFF%The crowd roars this time, so deafening that your ears crackle. It is good to see such energy. Once the fighting starts, there will be plenty of business as the righteous shall certainly find faith in the %companyname%. | A bearded cleric stands before a crowd of peasants.%SPEECH_ON%It is said that the old gods fought their wars to completion many years ago, that they tore this world asunder, and left us in the devastation, and they have been impressed by our ability to persevere against such great struggle.%SPEECH_OFF%The crowd murmurs. The man continues.%SPEECH_ON%But we are challenged yet, ye faithful! To the south wander heretics, followers of the \'Gilder\', a false god of opulence, profligacy, and a lowly prestidigitation they pass for righteousness.%SPEECH_OFF%The crowd doesn\'t know what any of those words mean, but they raise their pitchforks to the air and roar, beckoning the clerics to tell them where to go. Smiling, the elders turn to one another and nod. You have little care for who or what is starting this crusade between north and south, only that the %companyname% will stand to earn a fair bit of coin in the gross matter. | The arsenal assembled before you is unlike any you\'ve ever seen. Armaments piled higher than three men head to feet. Soldiers are lined up, half of them holding religious banners, each adorned with one of the old gods. Clerics and monks walk the lines, speaking to the matter in both earthly and heavenly tones. This is the crusade, the great religious arrest of the northerners to take on the Gilder\'s followers.%SPEECH_ON%Sellsword, are ye?%SPEECH_OFF%You turn to see a young lad gearing up.%SPEECH_ON%You\'ll be on the righteous path, I know it, and the old gods will watch over us all. Do by them well, little scapegrace.%SPEECH_OFF%Of course. But first you\'ll do right by the %companyname% and getting a fat purse from all the action to come.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "War is upon us.",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_holywar_start"))
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();
			local nearTown = false;
			local town;

			foreach( t in towns )
			{
				if (t.isSouthern())
				{
					continue;
				}

				if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
				{
					nearTown = true;
					town = t;
					break;
				}
			}

			if (!nearTown)
			{
				return;
			}

			this.m.Town = town;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_holywar_start");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

