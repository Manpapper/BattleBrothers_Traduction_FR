this.volunteers_event <- this.inherit("scripts/events/event", {
	m = {
		Dude1 = null,
		Dude2 = null,
		Dude3 = null
	},
	function create()
	{
		this.m.ID = "event.volunteers";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_80.png[/img]{You are sitting in your tent and flipping a quill pen through your fingers. Awhile back you saw a scribe doing it, but you can\'t figure out how he did it so fast without dropping the damned thing. Even a breeze carries out from your shuffling fingers. %randombrother% shakes his head.%SPEECH_ON%Will we ever financially recover from this?%SPEECH_OFF%Sighing, you look up. You\'d hoped the men would keep it together and not fret over losses but given a whole series of recent events the company almost seems on the precipice of incurring irreversible damage. Morale is low, the treasury is low, but even if you had the monies it seems like many might not even wish to join the company anyway given its lousy performance. Just then, a sellsword enters your camp with three men in tow. The man in front introduces himself, then makes his case.%SPEECH_ON%We knew of the %companyname% for its reputation, and we marched far to see it for ourselves. Now, if I may speak honestly, y\'all seem beat to hell and not at all like the stories spoke of, but, shite, we know this world is hard on people and the only thing to do is make hay of it. We didn\'t walk all this way to get upset at a little scuff, y\'know?%SPEECH_OFF%The men offer their services without upfront hiring costs, and not only this but the rest of the company is emboldened by the fact that the world still thinks highly of them and their efforts. All that time spent furnishing the %companyname%\'s renown has finally paid off.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome aboard.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude1);
						this.World.getPlayerRoster().add(_event.m.Dude2);
						this.World.getPlayerRoster().add(_event.m.Dude3);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude1.onHired();
						_event.m.Dude2.onHired();
						_event.m.Dude3.onHired();
						return 0;
					}

				},
				{
					Text = "We\'re good, thanks.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude1 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude1.setStartValuesEx([
					"bastard_background",
					"caravan_hand_background",
					"deserter_background",
					"houndmaster_background"
				]);
				_event.m.Dude1.getBackground().buildDescription(true);
				_event.m.Dude2 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude2.setStartValuesEx([
					"killer_on_the_run_background",
					"gambler_background",
					"graverobber_background",
					"poacher_background",
					"thief_background"
				]);
				_event.m.Dude2.getBackground().buildDescription(true);
				_event.m.Dude3 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude3.setStartValuesEx([
					"butcher_background",
					"gravedigger_background",
					"mason_background",
					"miller_background",
					"miner_background",
					"peddler_background",
					"ratcatcher_background",
					"shepherd_background",
					"tailor_background"
				]);
				_event.m.Dude3.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude1.getImagePath());
				this.Characters.push(_event.m.Dude2.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local fallen = [];
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 5)
		{
			return;
		}

		if (fallen[0].Time > this.World.getTime().Days + 7 || fallen[1].Time > this.World.getTime().Days + 7 || fallen[2].Time > this.World.getTime().Days + 7 || fallen[3].Time > this.World.getTime().Days + 7 || fallen[4].Time > this.World.getTime().Days + 7)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() + 3 >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1800 || this.World.Assets.getMoney() > 1500)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude1 = null;
		this.m.Dude2 = null;
		this.m.Dude3 = null;
	}

});

