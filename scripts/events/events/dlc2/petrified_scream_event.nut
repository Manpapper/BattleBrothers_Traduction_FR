this.petrified_scream_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.petrified_scream";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]{Quelques hommes se précipitent dans votre tente, les yeux écarquillés et en sueur. Ils se dérobent distraitement au contact des autres ou les repoussent violemment. Vous demandez quel est le problème et ils vous expliquent comme un groupe d\'oiseau que vous souhaiteriez nourrir. Il faut un peu d\'analyse, mais il semble que l\'artefact appelé par superstition le \"cri pétrifié\" ait donné des cauchemars aux hommes. Vous dites aux hommes que l\'objet est dans l\'inventaire et qu\'il n\'est pas dangereux. Les hommes partent tranquillement.\n\n Vous retournez à votre carte pour voir quelque chose de noir caché sous le papier. En soulevant la page, vous trouvez le masque de l\'alp mort, la gueule ouverte dans une permanence noire et macabre. Vous fixez le masque, vous pouvez entendre quelque chose à l\'intérieur, quelque chose qui fait claquer ses dents comme des dés lancés, et les côtés du masque semblent vibrer, donnant à sa chair un aspect bouillonnant. Avec un haussement d\'épaules et un rire, vous le jetez sur la carte comme presse-papier. Cette satanée chose va se perdre si les hommes continuent à la déplacer comme ça.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Comment faites-vous pour continuer à égarer ça ?",
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
						bro.worsenMood(0.75, "Inquiet de transporter un artefact de cri pétrifié.");

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

