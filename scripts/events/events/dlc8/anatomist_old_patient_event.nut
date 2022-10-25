this.anatomist_old_patient_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_old_patient";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_77.png[/img]{Les habitants de %townname% ont généralement considéré les anatomistes et vous comme des démons égarés. Mais soudain, un homme descend de son porche et traverse la route à grandes enjambées en direction de %anatomist% l\'anatomiste, avec une posture droite, une démarche chaloupée et un grand sourire. Il saisit l\'anatomiste par la main et commence à la secouer vigoureusement.%SPEECH_ON%Merde, je me doutais que vous reviendriez un de ces jours! Vous ne me reconnaissez pas? Vous êtes passé par ici il y a des années, on paraissait tous les deux un peu plus jeunes à l\'époque. J\'avais une grosse masse noire dans le dos que vous m\'avez enlevé, et ma vie s\'est beaucoup améliorée depuis! Bon sang, donnez-moi une seconde, ne bougez pas d\'un poil, je reviens tout de suite!%SPEECH_OFF%L\'homme retourne rapidement chez lui. Vous regardez %anatomiste% qui remarque qu\'il se souvient de l\'homme: il avait une tumeur géante qui lui poussait sur la colonne vertébrale, et l\'anatomiste, dans sa jeunesse, avait réussi à la couper en utilisant des pinces, des lames de cisaillement et un bon nombre de chiffons. Il regrette de ne pas avoir gardé la masse charnue pour l\'étudier, mais il était un autre type de praticien à l\'époque. L\'homme revient avec une arme qu\'il tend.%SPEECH_ON%Une fois en bonne santé, je me suis lancé dans la lutte contre le cancer. J\'étais plutôt bon à ça aussi, mais vous savez, les vies changent, et continuent de changer. Je vous ai vu avec ce mercenaire ici, donc je suppose que ça a changé pour vous aussi. S\'il vous plaît, prenez-le.%SPEECH_OFF%A la seconde où l\'anatomiste hésite, vous prenez l\'arme vous-même, de peur que l\'occasion charitable ne soit de courte durée. Vous remerciez l\'homme. Il serre à nouveau la main de %anatomist%, puis lui dit au revoir. L\'anatomiste le regarde fixement pendant qu\'il s\'en va.%SPEECH_ON%On pourrait faire des expériences sur lui, maintenant que je me souviens de tout ce que je sais à son propos. La masse qu\'il avait sur son dos va probablement revenir, je pourrais peut-être... juste... l\'ouvrir et jeter un œil...%SPEECH_OFF%Vous empêchez l\'anatomiste d\'avoir envie de disséquer les laïcs locaux et vous reprenez la route.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous trouverez d\'autres masses noires à traiter ailleurs.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local weapons = [
					"weapons/arming_sword",
					"weapons/winged_mace",
					"weapons/warhammer",
					"weapons/fighting_spear",
					"weapons/fighting_axe",
					"weapons/military_cleaver"
				];
				local weapon = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				this.World.Assets.getStash().add(weapon);
				this.List.push({
					id = 10,
					icon = "ui/items/" + weapon.getIcon(),
					text = "You gain " + weapon.getName()
				});

				if (this.Math.rand(1, 100) <= 75)
				{
					_event.m.Anatomist.improveMood(0.75, "Saw living proof that his past work was successful");
				}
				else
				{
					_event.m.Anatomist.improveMood(0.5, "An old patient thanked him for his medical help");
				}

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
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

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Town = null;
	}

});

