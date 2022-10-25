this.disowned_noble_welcomed_back_event <- this.inherit("scripts/events/event", {
	m = {
		Disowned = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.disowned_noble_welcomed_back";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Dans %townname%, vous recevez une lettre d\'un messager. Il vous demande de ne pas la lire, mais dès qu\'il est au coin de la rue, vous le faites en brisant le sceau royal en cire. Vous lisez que %disowned%, le noble désavoué, n\'est plus exilé. Au contraire, sa place sera sur le trône familial dès que son père, déjà gravement malade, sera décédé. Vous tenez la lettre dans votre main, ne sachant pas quoi en faire. %disowned% a longtemps été un membre de la compagnie %companyname%. Pour certains, il y a un charme étrange pour cet homme qui était autrefois dans toutes les salles royales du monde et qui se retrouve maintenant dans les véritables bas-fonds d\'une compagnie de mercenaires. Mais si une lignée peut se tarir, un lignage ne meurt jamais vraiment...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je vais lui montrer la lettre.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Je vais brûler la lettre.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_82.png[/img]{Soupirant en pensant à ce qui pourrait se passer, vous décidez d\'aller lui montrer la lettre. Il la lit longuement, puis lève les yeux.%SPEECH_ON%Je sais que vous l\'avez lu.%SPEECH_OFF%Il tend la lettre vers vous.%SPEECH_ON%Et je sais que vous auriez pu tout aussi bien brûler cette lettre. Mais vous ne l\'avez pas fait. Ça ne fait que me montrer ce que je sais déjà: la compagnie %companyname% est ma famille maintenant. Si vous voulez que je reste, je reste, si vous voulez que je parte, je pars.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je pense que vous devriez rester avec nous.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Vous devriez rentrer chez vous, auprès de votre famille.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_82.png[/img]{Vous reprenez la lettre, puis vous l\'amenez vers une bougie proche. Elle brûle rapidement, les cendres s\'échappant du bout de vos doigts à mesure que le feu brule le papier. %disowned% fait un signe de tête.%SPEECH_ON%Je suis content que vous l\'ayez fait. Si ma patrie a besoin de moi, je ne reviendrai que lorsque mon travail avec la compagnie %companyname% sera terminé. Mais jusque-là, vous aurez mon épée, ma sueur et mon sang.%SPEECH_OFF%Il sourit.%SPEECH_ON%Si la paye est correcte, bien sûr. Je suis, malgré tout, encore un mercenaire.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien sûr.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				local background = this.new("scripts/skills/backgrounds/regent_in_absentia_background");
				_event.m.Disowned.getSkills().removeByID("background.disowned_noble");
				_event.m.Disowned.getSkills().add(background);
				_event.m.Disowned.m.Background = background;
				background.buildDescription();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Disowned.getName() + " is now a Regent in Absentia"
					}
				];
				local resolve_boost = this.Math.rand(10, 15);
				local initiative_boost = this.Math.rand(6, 10);
				local melee_defense_boost = this.Math.rand(2, 4);
				local ranged_defense_boost = this.Math.rand(3, 5);
				_event.m.Disowned.getBaseProperties().Bravery += resolve_boost;
				_event.m.Disowned.getBaseProperties().Initiative += initiative_boost;
				_event.m.Disowned.getBaseProperties().MeleeDefense += melee_defense_boost;
				_event.m.Disowned.getBaseProperties().RangedDefense += ranged_defense_boost;
				_event.m.Disowned.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Disowned.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve_boost + "[/color] Resolve"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Disowned.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative_boost + "[/color] Initiative"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Disowned.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_defense_boost + "[/color] Melee Defense"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.Disowned.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + ranged_defense_boost + "[/color] Ranged Defense"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_74.png[/img]{Vous lui remettez la lettre en main propre.%SPEECH_ON%Je pense qu\'un homme éloigné de sa famille a davantage besoin d\'elle lorsqu\'elle le rappelle, et cela doit être important. Votre temps avec la compagnie %companyname% est terminé.%SPEECH_OFF%Au début, le noble désavoué semble abattu, mais il commence ensuite à hocher la tête, approuvant votre décision de dire que sa famille doit avoir besoin de lui et qu\'il ne devrait pas les laisser dans le pétrin. Il vous dit au revoir, ainsi qu\'au reste de la compagnie. Mais avant de partir pour de bon, il vous a préparé une lettre.%SPEECH_ON%Vous aurez mes remerciements, capitaine. Vous ne pensiez pas que j\'allais partir sans reconnaître à quel point vous avez contribué à me sauver la vie, parce que c\'est précisément ce que vous avez fait, que vous le réalisiez ou non.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "De rien, %disowned%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Disowned.getName() + " leaves the " + this.World.Assets.getName()
				});
				_event.m.Disowned.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Disowned.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Disowned);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnAmbition);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_98.png[/img]{Il n\'y a pas moyen que vous montriez ça à %disowned%. Vous brûlez rapidement la lettre et tous les détails de son retour dans la lignée familiale. À ce moment-là, il arrive au coin de la rue. Il a l\'air un peu perplexe et demande s\'il y a un problème. Vous secouez la tête et lui demandez s\'il veut aider à compter l\'inventaire. %disowned% sourit.%SPEECH_ON%Bien sûr. La compagnie %companyname% ne peut pas être compétente sans un bon inventaire, ou sans vos ordres, capitaine.%SPEECH_OFF%Au moment où vous commencer à faire l\'inventaire, vous voyez le messager de tout à l\'heure en train de tirer quelque chose. Vous laissez %disowned% à sa tâche pour aller vers l\'homme. Il tire un coffre très lourd vers lui, puis s\'essuie le front en précisant que celui-ci était également destiné au noble désavoué. Vous l\'ouvrez d\'un coup de pied pour trouver une litanie d\'armes et d\'armures, dont certaines portent les armoiries de sa famille. Vous remerciez le messager, puis vous vous empressez de briser les blasons et de jeter les emblèmes dans les caniveaux de peur que le noble ne les voie. Curieux, il demande si tout va bien. Vous secouez la tête.%SPEECH_ON%Oui, tout va bien. J\'ai juste reçu une livraison de nouveau matériel, c\'est tout.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il n\'y a rien à voir ici.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local stash = this.World.Assets.getStash();
				local armor_list = [
					"mail_hauberk",
					"reinforced_mail_hauberk"
				];

				if (this.Const.DLC.Unhold)
				{
					armor_list.extend([
						"footman_armor",
						"light_scale_armor",
						"sellsword_armor",
						"noble_mail_armor"
					]);
				}

				local weapons_list = [
					"noble_sword",
					"fighting_spear",
					"fighting_axe",
					"warhammer",
					"winged_mace",
					"arming_sword",
					"warbrand"
				];
				item = this.new("scripts/items/armor/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/" + weapons_list[this.Math.rand(0, weapons_list.len() - 1)]);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/" + weapons_list[this.Math.rand(0, weapons_list.len() - 1)]);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
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

		local brothers = this.World.getPlayerRoster().getAll();
		local disowned_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.disowned_noble" && bro.getLevel() >= 6)
			{
				disowned_candidates.push(bro);
			}
		}

		if (disowned_candidates.len() == 0)
		{
			return;
		}

		this.m.Disowned = disowned_candidates[this.Math.rand(0, disowned_candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 4 * disowned_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"disowned",
			this.m.Disowned.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Disowned = null;
		this.m.Town = null;
	}

});

