this.oathtakers_all_oaths_complete_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.oathtakers_all_oaths_complete";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{The last of Young Anselm\'s Oaths have been completed. The Oathtakers have truly earned their name! Just one question remains: what now? You were never certain of what would happen once the First Oathtaker\'s oaths had been completed, and now that you have completed them, something is dawning on you and the rest of the company: to keep going. Why turn back now? Who wants to go back to the old, unguided life? Moribund and listless, floating through life without purpose? Surely that is not what Young Anselm intended by starting on the Final Path. You tell the men that every Oath has its meaning, and perhaps it is all the Oaths together which form a meaning of their own. The path of the Oathtaker ends when the Oathtaker wishes it to be so. You look out at the group of men.%SPEECH_ON%If you believe yourself free of the need for the Oaths, then please, leave.%SPEECH_OFF%A wave of pensive stares at the ground washes over the group. Eventually one looks up.%SPEECH_ON%There is only one way to leave Young Anselm\'s guidance, and that is to join him!%SPEECH_OFF%The group cheers. To Young Anselm, and to finding his jawbone, and to killing all Oathbringers!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To Young Anselm!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(2.0, "Completed all of Young Anselm\'s oaths");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}

					bro.getBaseProperties().Bravery += 1;
					this.List.push({
						id = 16,
						icon = "ui/icons/bravery.png",
						text = bro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local all_oaths_complete = this.World.Ambitions.getAmbition("ambition.oath_of_camaraderie").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_distinction").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_dominion").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_endurance").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_fortification").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_honor").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_humility").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_righteousness").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_sacrifice").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_valor").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_vengeance").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_wrath").isDone();

		if (!all_oaths_complete)
		{
			return;
		}

		this.m.Score = 600;
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

