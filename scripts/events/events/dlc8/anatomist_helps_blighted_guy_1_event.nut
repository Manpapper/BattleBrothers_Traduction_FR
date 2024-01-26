this.anatomist_helps_blighted_guy_1_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_helps_blighted_guy_1";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Vous tombez sur un homme enterré vivant, c\'est ce que vous déduisez du fait qu\'il est ligoté comme un mort et qu\'il continue de crier à propos d\'une histoire. Vous demandez ce qui se passe et l\'un des creuseurs se retourne et tend sa main.%SPEECH_ON%Gardez vos distances. Cet homme est contaminé et tous ceux qu\'il touche le deviennent. Nous ne voulons pas de maladie et vous non plus.%SPEECH_OFF%L\'homme crie à l\'aide quand une autre motte de terre atterrit sur lui. Il tente de sortir de la tombe, mais l\'un des creuseurs l\'y renvoie à coups de pied,  lui-même se plaignant qu\'il devra brûler sa botte préférée. %anatomiste% s\'approche d\'une voix calme. Il dit que l\'homme souffre d\'une maladie de peau qui pourrait ressembler à la lèpre ou à une peste, mais qui est en fait bénigne. Vous lui demandez s\'il en est sûr, il acquiesce, bien qu\'avec un doigt de réticence en l\'air.%SPEECH_ON%Je peux me tromper, bien sûr. Et si c\'est le cas, alors sa maladie pourrait nous contaminer. Mais enterrer un homme vivant n\'est pas quelque chose que je trouve, comment dire, scientifiquement convaincant.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dans ce cas, nous allons l\'aider.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Ce n\'est pas notre problème.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Vous dégainez votre épée et ordonnez aux creuseurs de s\'arrêter. Ils vous regardent d\'un air incrédule. L\'un d\'eux pointe du doigt l\'homme dans la tombe.%SPEECH_ON%Vous n\'avez pas entendu ? Ce type est fichu. Ce que nous faisons ici n\'a peut-être pas l\'air bien mais-%SPEECH_OFF%D\'un coup d\'épée, l\'homme se tait. Vous dites à la personne dans la tombe de sortir, ce qu\'il fait, les creuseurs laissent tomber leurs pelles et reculent. Ils vous disent qu\'il est tout à vous. L\'homme supposé malade s\'approche, toujours effrayé et sans doute incertain si ses sauveteurs ont quelque chose de mieux à l\'esprit pour lui que ceux qui l\'enterreraient vivant. %anatomiste% le prend sous son aile et vous vous reculez doucement. L\'anatomiste déclare que l\'homme est malade, mais que ce n\'est pas grave et qu\'il se remettra en temps voulu. Mais pour l\'instant, il a besoin de repos.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Nous n\'avons besoin de personne d\'autre",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return "D";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"vagabond_background"
				], false);
				_event.m.Dude.setTitle("");
				_event.m.Dude.getFlags().set("IsSpecial", true);
				_event.m.Dude.getBackground().m.RawDescription = "" + _event.m.Anatomist.getNameOnly() + " l'Anatomiste a sauvé %name% d'être enterré vivant pour avoir porté une maladie étrange. Maintenant, il a le plaisir unique de porter à la fois la peste ET d'être un cobaye pour certains chercheurs. Restez là-bas, s'il vous plaît.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.m.Talents = [];
				local talents = _event.m.Dude.getTalents();
				talents.resize(this.Const.Attributes.COUNT, 0);
				talents[this.Const.Attributes.MeleeSkill] = 2;
				talents[this.Const.Attributes.MeleeDefense] = 2;
				talents[this.Const.Attributes.Bravery] = 2;
				_event.m.Dude.m.Attributes = [];
				_event.m.Dude.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				_event.m.Dude.worsenMood(1.5, "Was almost buried alive for bearing a disease");
				local i = this.new("scripts/skills/injury/sickness_injury");
				i.addHealingTime(8);
				_event.m.Dude.getSkills().add(i);
				_event.m.Dude.getFlags().set("IsMilitiaCaptain", true);
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_18.png[/img]{Dans le plus réticent des sauvetages, vous soupirez et dégainez votre épée, ordonnant aux creuseurs d\'arrêter immédiatement. Ils vous regardent, les mains sur leurs pelles, les sourcils froncés.%SPEECH_ON%Quoi? Vous ne nous avez pas entendus? Le gars est foutu!%SPEECH_OFF%%anatomiste% s\'avance et leur fait signe de partir. Vous hochez la tête et faites un geste pour que les creuseurs fassent ce qu\'on leur dit. L\'anatomiste aide l\'homme à sortir de la tombe, bien que vous remarquiez qu\'il le fait avec ses propres mais recouvertes par ses manches. On l\'aide à rejoindre la compagnie. Alors que l\'homme se retourne pour le remercier, l\'anatomiste lui assène un coup de marteau à l\'arrière de la tête, l\'assommant immédiatement. L\'anatomiste le retient dans sa chute et commencer à découper le bras de l\'homme, retirant un morceau de chair avant de reculer.%SPEECH_ON%Cela devrait être suffisant pour nos études, je crois.%SPEECH_OFF%Vous demandez si l\'homme était effectivement malade. L\'anatomiste acquiesce.%SPEECH_ON%Bien évidemment, il est plus utile en étant malade à nos côtés plutôt qu\'enterré vivant. A partir de maintenant, il peut crever. Il n\'y a plus grand chose pour lui dans ce monde.%SPEECH_OFF%L\'homme gémit en se tordant sur le sol. Un petit bruit dans ses bottes vous interpelle. Une fois enlevées, vous trouvez des couronnes bien rangées. Vous envisagez brièvement d\'abréger ses souffrances, mais vous décidez que maintenant qu\'il est libéré de la tombe, il peut décider lui-même de la manière dont il souhaite y retourner. Toutefois, vous prenez son argent.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bonne chance, mec.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Got to study an unusual blight");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				this.World.Assets.addMoney(45);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]45[/color] Crowns"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous dites à l\'homme que la compagnie %companyname% n\'a pas besoin de plus de mercenaires. Vous laissez également entendre qu\'avant de partir, il devrait peut-être envisager de vous dédommager pour votre aide. Il acquiesce et enlève sa botte, révélant de l\'or caché à l\'intérieur. Ne sachant pas de quelle maladie il souffre, vous lui dites de frotter les pièces sur l\'herbe puis de les retourner avec ses pieds. Il fait ce qu\'on lui dit. Il hoche la tête.%SPEECH_ON%Bien. J\'apprécie. Prenez soin de vous.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bonne chance à vous aussi",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(65);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]65[/color] Crowns"
				});

				if (this.Math.rand(1, 100) < 75)
				{
					_event.m.Anatomist.worsenMood(0.75, "Was denied the study of an unusual illness");
				}
				else
				{
					_event.m.Anatomist.worsenMood(0.5, "Was denied the chance to help a sick man");
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

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() > 0)
		{
			this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		}
		else
		{
			return;
		}

		this.m.Score = 5 + anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Dude = null;
	}

});

