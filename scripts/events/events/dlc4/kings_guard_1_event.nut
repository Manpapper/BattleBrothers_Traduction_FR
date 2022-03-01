this.kings_guard_1_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.kings_guard_1";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Les étendues enneigées n'abritent pas grand-chose, alors trouver un homme à moitié nu dans cette géographie glaciale est plutôt inhabituel. Qu'il soit en vie l'est encore plus. Vous vous accroupissez près de lui. Ses yeux sont creux et le givre rend leur clignement difficile. Ses lèvres sont dentelées et violettes. Son nez est d'un rouge profond, à la limite du noir. Vous lui demandez s'il peut parler. Il acquiesce.%SPEECH_ON%Barbares. Mon. enlevé.%SPEECH_OFF%Vous demandez où sont ses ravisseurs. Il hausse les épaules et continue sa cadence glacé.%SPEECH_ON%Ils. S'ennuyaient. Et. Sont. Partis.%SPEECH_OFF%Ça semble en accord avec les primitifs de laisser un prisonnier dans la glace. Il explique qu'il était autrefois un robuste combattant à l'épée. Un sourire se dessine à travers la douleur.%SPEECH_ON%A. Garde. Du Roi. Dans. La. Région. Sans-Roi. Les choses. Pourraient-elle. Etre. Pire ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous avons une place pour toi, mon ami.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Vous êtes seul dans ce monde.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cripple_background"
				], false);
				_event.m.Dude.setTitle("");
				_event.m.Dude.getBackground().m.RawDescription = "Vous avez trouvé %name% à moitié gelé dans le nord. Il prétend avoir été garde du roi, mais en le regardant, vous ne voyez qu'un infirme.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getFlags().set("IsSpecial", true);
				_event.m.Dude.getBaseProperties().Bravery += 15;
				_event.m.Dude.getSkills().update();
				_event.m.Dude.m.PerkPoints = 2;
				_event.m.Dude.m.LevelUps = 2;
				_event.m.Dude.m.Level = 3;
				_event.m.Dude.m.XP = this.Const.LevelXP[_event.m.Dude.m.Level - 1];
				_event.m.Dude.m.Talents = [];
				local talents = _event.m.Dude.getTalents();
				talents.resize(this.Const.Attributes.COUNT, 0);
				talents[this.Const.Attributes.MeleeSkill] = 2;
				talents[this.Const.Attributes.MeleeDefense] = 3;
				talents[this.Const.Attributes.RangedDefense] = 3;
				_event.m.Dude.m.Attributes = [];
				_event.m.Dude.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(1.5, "A été enlevé par des barbares et laissé mourir dans le froid.");
				_event.m.Dude.getFlags().set("IsKingsGuard", true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{Vous tapotez la tête de l'homme, mais lui dites que c'est déjà fini. Il acquiesce.%SPEECH_ON%Parlez. Pour. Vous-même. Mercenaire.%SPEECH_OFF%Il sourit à nouveau, mais cette fois, il se détache. Il se colle. Littéralement. Et il se penche en avant, ses yeux sont ouverts et ne clignent pas, et dans cet état, il est parti. Vous remettez les hommes sur la route, ou ce qu'on peut faire d'une route dans ces étendues enneigées.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C'est déjà fini pour vous.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{L'homme presque gelé rejoint la compagnie. C'est une épave en lambeaux, mais si ce qu'il a dit est vrai, peut-être deviendra-t-il un jour le combattant dont il pouvait à peine parler.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous verrons bien.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
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

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

