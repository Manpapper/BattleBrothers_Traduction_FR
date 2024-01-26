this.anatomist_helps_blighted_guy_2_event <- this.inherit("scripts/events/event", {
	m = {
		MilitiaCaptain = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_helps_blighted_guy_2";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_58.png[/img]{L\'homme prétendument malade que les anatomistes avaient sauvé de la tombe se manifeste. Il est plus beau que jamais. Il remercie les anatomistes pour leur travail, bien qu\'ils ne le considèrent guère. Il semble qu\'il était plus intéressant pour eux lorsqu\'il était souffrant et qu\'ils pouvaient le tripoter pour en apprendre plus sur sa maladie. Il y avait un certain espoir de la part des anatomistes de le voir mort pour en apprendre encore plus. Voyant cela, l\'homme se tourne vers vous.%SPEECH_ON%J\'apprécie beaucoup, j\'espère au moins que vous le savez. Vous n\'imaginez pas l\'enfer que j\'ai vécu avec ceux qui ont essayé de m\'enterrer vivant. Je pense qu\'ils savaient que je n\'étais pas malade, ils voulaient juste ma propriété. Vous voyez, j\'ai l\'habitude de diriger la milice locale, mais cela veut dire aussi d\'encaisser une certaine jalousie patente de mes rivaux ainsi que diverses conspirations.%SPEECH_OFF%Il se frotte l\'arrière de la tête, puis décide de prendre la parole.%SPEECH_ON%Ces fossoyeurs m\'ont tout pris, je n\'ai plus rien. Donc, eh bien, laissez-moi juste dire que je suis heureux de me battre pour vous et de me faire une nouvelle vie ici.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Content que vous vous sentiez mieux, %militiacaptain%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.MilitiaCaptain.getImagePath());
				local bg = this.new("scripts/skills/backgrounds/militia_background");
				bg.m.IsNew = false;
				_event.m.MilitiaCaptain.getSkills().removeByID("background.vagabond");
				_event.m.MilitiaCaptain.getSkills().add(bg);
				_event.m.MilitiaCaptain.getBackground().m.RawDescription = "Vous avez trouvé %name% en train d'être enterré vivant pour avoir porté une maladie inconnue. Les anatomistes ont manifesté de l'intérêt pour lui et l'ont sauvé, le soignant pour le ramener à la santé. Maintenant, il se bat pour vous, mettant à profit les compétences qui ont fait de lui le capitaine de la garde dans une vie antérieure.";
				_event.m.MilitiaCaptain.getBackground().buildDescription(true);
				_event.m.MilitiaCaptain.improveMood(1.0, "Recovered from the blight afflicting him");

				if (_event.m.MilitiaCaptain.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.MilitiaCaptain.getMoodState()],
						text = _event.m.MilitiaCaptain.getName() + this.Const.MoodStateEvent[_event.m.MilitiaCaptain.getMoodState()]
					});
				}

				_event.m.MilitiaCaptain.getBaseProperties().MeleeDefense += 4;
				_event.m.MilitiaCaptain.getBaseProperties().RangedDefense += 4;
				_event.m.MilitiaCaptain.getBaseProperties().MeleeSkill += 8;
				_event.m.MilitiaCaptain.getBaseProperties().RangedSkill += 7;
				_event.m.MilitiaCaptain.getBaseProperties().Stamina += 3;
				_event.m.MilitiaCaptain.getBaseProperties().Initiative += 6;
				_event.m.MilitiaCaptain.getBaseProperties().Bravery += 12;
				_event.m.MilitiaCaptain.getBaseProperties().Hitpoints += 5;
				_event.m.MilitiaCaptain.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.MilitiaCaptain.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+4[/color] Melee Defense"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.MilitiaCaptain.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+4[/color] Ranged Defense"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.MilitiaCaptain.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+8[/color] Melee Skill"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.MilitiaCaptain.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+7[/color] Ranged Skill"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.MilitiaCaptain.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] Max Fatigue"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.MilitiaCaptain.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+6[/color] Initiative"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.MilitiaCaptain.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+12[/color] Resolve"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.MilitiaCaptain.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] Hitpoints"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidate;

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury) && !bro.getSkills().hasSkillOfType(this.Const.SkillType.SemiInjury) && bro.getDaysWithCompany() >= 5 && bro.getFlags().get("IsMilitiaCaptain"))
			{
				candidate = bro;
				break;
			}
		}

		if (candidate == null)
		{
			return;
		}

		this.m.MilitiaCaptain = candidate;
		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"militiacaptain",
			this.m.MilitiaCaptain.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.MilitiaCaptain = null;
	}

});

