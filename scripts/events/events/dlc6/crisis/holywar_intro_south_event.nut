this.holywar_intro_south_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_intro_south";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%SPEECH_START%May our paths be gilded in the days to come.%SPEECH_OFF%The priest speaks loudly to his congregation.%SPEECH_ON%I ask of you, faithful, where is the light brightest?%SPEECH_OFF%A throng of peasants murmur about themselves. Finally, the priest holds his hand up.%SPEECH_ON%It is upon the horizon, fighting against the shade of the earth herself, that we find the Gilder\'s gleam to be its fiercest. And we are now fighting against the shade, and the horizon is not the earth, but the improprieties of the northern stock who dare to profane the holy lands!%SPEECH_OFF%The crowd, once confused, is suddenly unified, seemingly all too knowledgeable about religious war. The priest grins.%SPEECH_ON%That is right, I see your hearts burn with the fire of the Gilder already! We must defend the sacred grounds no matter the cost!%SPEECH_OFF%Again, the crowd roars. You\'re not sure what to make of the peoples themselves, but if there\'s one thing you know about war it is that it is good for business and a bit of holy fury might make it all the better. | The Vizier has made a rare appearance for the plebs of his land, and beside him is the greater councils of nearby cities. But he does not speak. A man clothed in gold steps forward instead.%SPEECH_ON%The path of us all has been gilded, has it not?%SPEECH_OFF%Far less gleaming than the priest, the crowd murmur amongst themselves, though none dare to contradict the holy man\'s assertion. The priest continues.%SPEECH_ON%The Gilder has spoken to many of us, and revealed to us a new event threat: the northerners, spurred by their so-called old gods, have swept south. They entertain the thought of a crusade! To come here, right here, and take all our lands and sacred grounds. You see, the Gilder\'s shine shows us the path, but perhaps to others it is far too blinding. These northerners do not understand, but we will teach them, and by the Gilder\'s fire we shall!%SPEECH_OFF%The crowd roars to life and any sense of hesitancy is long gone. You chow down on a local delicatessen and wonder just how much money you\'re going to make in this holy war to come.}",
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
				if (!t.isSouthern())
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

