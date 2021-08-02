this.cultist_vs_old_gods_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		OldGods = null
	},
	function create()
	{
		this.m.ID = "event.cultist_vs_old_gods";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]Alors que vous savourez une tranche de bacon, vous entendez le bruit d\'une querelle. Vous l\'ignorez pendant un moment, mais les cris ne font que s\'amplifier, prenant rapidement le pas sur votre capacité à apprécier un bon repas. En colère, vous vous levez et vous vous dirigez vers la perturbation. Vous trouvez %cultist% et %oldgods% en train de s\'affronter, le cultist et le partisan des dieux ayant apparemment quelques différends.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Soyons pieux avec les plus gores !",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Arrêtez ces bêtises.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OldGods.getImagePath());
				this.Characters.push(_event.m.Cultist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img] Vous vous mettez à l\'écart, laissant les hommes régler leurs différends comme des hommes. Les poings en guise d\'arguments, l\'adepte des anciens dieux fait valoir ses arguments, frappant le cultistes encore et encore. Mais l\'homme à la tête balafrée ne fait que sourire en retour. Ses yeux sont bouffis, les paupières empourprées et froncées sur sa vue. Pourtant, il sourit toujours, et un rire sanglant s\'échappe de sa bouche rougie.%SPEECH_ON%Une telle obscurité ! Davkul est très heureux !%SPEECH_OFF%Avec un regard inquiet, %oldgods% se détache de %cultist% et recule. Il frotte ses articulations ensanglantées, réalisant qu\'il en a peut-être cassé quelques-unes dans cette bagarre apparemment unilatérale. Mais ce sont les mots du cultiste qui l\'ont le plus blessé.%SPEECH_ON%L\'homme n\'est pas tenté par les ténèbres, il y est appelé ! Sans elle, il est perdu ! Il se réjouit de son retour !%SPEECH_OFF%Ayant presque peur de se retourner, %oldgods% s\'éloigne en courant tandis que le cultiste reste derrière, riant et gloussant sur l\'herbe, personne n\'osant s\'approcher de lui.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je ne savais pas que %oldgods% avait ça en lui.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OldGods.getImagePath());
				this.Characters.push(_event.m.Cultist.getImagePath());
				_event.m.OldGods.worsenMood(1.0, "Il a perdu son sang-froid et a recouru à la violence");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.OldGods.getMoodState()],
					text = _event.m.OldGods.getName() + this.Const.MoodStateEvent[_event.m.OldGods.getMoodState()]
				});
				_event.m.OldGods.getBaseProperties().Bravery += -1;
				_event.m.OldGods.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.OldGods.getName() + " loses [color=" + this.Const.UI.Color.NegativeEventValue + "]-1[/color] de Détermination"
				});
				local injury = _event.m.Cultist.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Cultist.getName() + " souffre de " + injury.getNameOnly()
				});
				_event.m.Cultist.getBaseProperties().Bravery += 2;
				_event.m.Cultist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cultist.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] de Détermination"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_03.png[/img] Au train où vont les choses, vous n\'avez pas un homme de trop. Au moment où les poings sont sur le point de commencer à voler, vous vous interposez entre les deux hommes et mettez un terme à tout cela. Vous dites à %oldgods% qu\'il vaut mieux que ça, et vous ne dites rien à %cultist%, car le cultist est presque terrassé par des éclats de rire. Il vous montre du doigt en souriant comme un fou.%SPEECH_ON%La lumière entre, mais les ténèbres sont patientes. Davkul vous attend tous.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et le travail vous attend, bougez-vous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OldGods.getImagePath());
				this.Characters.push(_event.m.Cultist.getImagePath());
				_event.m.OldGods.worsenMood(1.0, "On lui a refusé la chance d\'éclairer un cultiste.");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.OldGods.getMoodState()],
					text = _event.m.OldGods.getName() + this.Const.MoodStateEvent[_event.m.OldGods.getMoodState()]
				});
				_event.m.Cultist.worsenMood(1.0, "On lui a refusé la chance de briser un adepte des anciens dieux.");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
					text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local cultist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);
			}
		}

		if (cultist_candidates.len() == 0)
		{
			return;
		}

		local oldgods_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.pacified_flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				oldgods_candidates.push(bro);
			}
		}

		if (oldgods_candidates.len() == 0)
		{
			return;
		}

		this.m.Cultist = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
		this.m.OldGods = oldgods_candidates[this.Math.rand(0, oldgods_candidates.len() - 1)];
		this.m.Score = (cultist_candidates.len() + oldgods_candidates.len()) * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist.getName()
		]);
		_vars.push([
			"oldgods",
			this.m.OldGods.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.OldGods = null;
	}

});

