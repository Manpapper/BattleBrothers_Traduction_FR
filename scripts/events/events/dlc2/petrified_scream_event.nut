this.petrified_scream_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.petrified_scream";
		this.m.Title = "During camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]{A few of the men run into your tent, each of them wide-eyed and sweating. They absentmindedly shrink from each other\'s touch or violently push back. You ask what is the problem and they explain as a mob like birds crowing at someone hiding a piece of bread from them. It takes some parsing, but it sounds as though the artifact superstitiously called the \'petrified scream\' has been giving the men nightmares. You tell the men the item is in the inventory and is of no harm. The men quietly leave.\n\n You return to your map only to see something black hidden under the paper. Lifting the page, you find the alp\'s death mask there, maw open in grisly black permanence. You stare at the mask, you can hear something within it, something clattering its teeth like thrown dice, and the sides of it seem to be vibrating, giving its flesh a bubbling look. With a shrug and laugh you throw it on top of the map as a paperweight. Damn thing is gonna get lost if the men keep moving it around like this.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "How do you keep misplacing that?",
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
					if (bro.getSkills().hasSkill("trait.fearless") || bro.getSkills().hasSkill("trait.brave"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.paranoid") || bro.getSkills().hasSkill("trait.dastard") || bro.getSkills().hasSkill("trait.craven") || bro.getSkills().hasSkill("trait.mad") || this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(0.75, "Concerned about carrying around a Petrified Scream artifact");

						if (bro.getMoodState() <= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local items = 0;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.petrified_scream")
			{
				items = ++items;
				break;
			}
		}

		if (items == 0)
		{
			return;
		}

		this.m.Score = items * 5;
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

